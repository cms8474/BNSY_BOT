package com.bnsy.bot.service.impl;

import com.bnsy.bot.dto.MemberDTO;
import com.bnsy.bot.mapper.MemberMapper;
import com.bnsy.bot.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 회원 관리 서비스
 * 
 * @author BNSY Team
 * @since 1.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;

    /**
     * 회원가입
     * 
     * @param memberDTO 회원가입 정보
     * @return 성공 시 true, 실패 시 false
     */
    @Override
    @Transactional
    public boolean registerMember(MemberDTO memberDTO) {
        log.info("회원가입 시도: {}", memberDTO.getMemberId());

        // 1. ID 중복 체크
        if (isIdDuplicate(memberDTO.getMemberId())) {
            log.warn("회원가입 실패: 이미 존재하는 아이디 - {}", memberDTO.getMemberId());
            return false;
        }

        // 2. 회원 정보 저장
        try {
            int result = memberMapper.insertMember(memberDTO);
            if (result > 0) {
                log.info("회원가입 성공: {}", memberDTO.getMemberId());
                return true;
            } else {
                log.error("회원가입 실패: DB INSERT 실패 - {}", memberDTO.getMemberId());
                return false;
            }
        } catch (Exception e) {
            log.error("회원가입 중 오류 발생: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 로그인 처리
     * 
     * @param memberId 회원 ID
     * @param memberPw 회원 비밀번호
     * @return 일치하는 회원 정보, 없으면 null
     */
    @Override
    public MemberDTO login(String memberId, String memberPw) {
        log.info("로그인 시도: {}", memberId);

        MemberDTO member = memberMapper.checkLogin(memberId, memberPw);

        if (member != null) {
            log.info("로그인 성공: {}", memberId);
        } else {
            log.warn("로그인 실패: ID 또는 비밀번호 불일치 - {}", memberId);
        }

        return member;
    }

    /**
     * 회원 정보 조회
     * 
     * @param memberId 조회할 회원 ID
     * @return 회원 정보, 존재하지 않으면 null
     */
    @Override
    public MemberDTO getMemberById(String memberId) {
        log.debug("회원 조회: {}", memberId);
        return memberMapper.findById(memberId);
    }

    /**
     * ID 중복 여부 확인
     * 
     * @param memberId 확인할 회원 ID
     * @return 중복이면 true, 중복 아니면 false
     */
    @Override
    public boolean isIdDuplicate(String memberId) {
        log.debug("ID 중복 체크 시작: {}", memberId);
        try {
            MemberDTO existingMember = memberMapper.findById(memberId);
            boolean isDuplicate = existingMember != null;
            log.debug("ID 중복 체크 결과: {} - 중복 여부: {}", memberId, isDuplicate);
            if (existingMember != null) {
                log.debug("조회된 회원 정보: {}", existingMember);
            }
            return isDuplicate;
        } catch (Exception e) {
            log.error("ID 중복 체크 중 오류 발생: {}", e.getMessage(), e);
            return true;
        }
    }
}
