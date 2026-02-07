package com.bnsy.bot.service;

import com.bnsy.bot.dto.MemberDTO;

public interface MemberService {

    /**
     * 회원가입
     * 
     * @param memberDTO 회원가입 정보 (아이디, 비밀번호, 가입목적)
     * @return 성공 시 true, 실패(ID 중복 등) 시 false
     */
    boolean registerMember(MemberDTO memberDTO);

    /**
     * 로그인
     * 
     * @param memberId 회원 ID
     * @param memberPw 회원 비밀번호
     * @return 일치하는 회원 정보, 없으면 null
     */
    MemberDTO login(String memberId, String memberPw);

    /**
     * 회원 정보 조회
     * 
     * @param memberId 조회할 회원 ID
     * @return 회원 정보, 존재하지 않으면 null
     */
    MemberDTO getMemberById(String memberId);

    /**
     * ID 중복 확인
     * 
     * @param memberId 확인할 회원 ID
     * @return 중복이면 true, 중복 아니면 false
     */
    boolean isIdDuplicate(String memberId);
}
