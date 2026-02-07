package com.bnsy.bot.mapper;

import com.bnsy.bot.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 회원 정보 Mapper 인터페이스
 * MEMBERS 테이블
 * 
 * @author BNSY Team
 * @since 1.0.0
 */
@Mapper
public interface MemberMapper {

    /**
     * 회원 정보 조회(인증용)
     * 
     * @param memberId 조회할 회원 ID
     * @return 회원 정보 (존재하지 않으면 null)
     */
    MemberDTO findById(@Param("memberId") String memberId);

    /**
     * 로그인 체크
     * 
     * @param memberId 회원 ID
     * @param memberPw 회원 비밀번호
     * @return 일치하는 회원 정보 (존재하지 않으면 null)
     */
    MemberDTO checkLogin(@Param("memberId") String memberId,
            @Param("memberPw") String memberPw);

    /**
     * 새 회원 등록
     * 
     * @param member 등록할 회원 정보
     * @return 삽입된 행의 개수 (1: 성공, 0: 실패)
     */
    int insertMember(MemberDTO member);

    /**
     * 회원 정보 수정
     * 
     * @param member 수정할 회원 정보
     * @return 수정된 행의 개수 (1: 성공, 0: 실패)
     */
    int updateMember(MemberDTO member);

    /**
     * 회원 삭제
     * 
     * @param memberId 삭제할 회원 ID
     * @return 삭제된 행의 개수 (1: 성공, 0: 실패)
     */
    int deleteMember(@Param("memberId") String memberId);
}
