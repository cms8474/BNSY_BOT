package com.bnsy.bot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 회원 정보 DTO (Data Transfer Object)
 * MEMBERS 테이블
 * 
 * @author BNSY Team
 * @since 1.0.0
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MemberDTO {

    /**
     * 회원 아이디 (Primary Key)
     * 
     */
    private String memberId;

    /**
     * 회원 비밀번호
     */
    private String memberPw;

    /**
     * 회원 이름
     */
    private String memberName;

    /**
     * 권한
     */
    private String role;

    /**
     * 가입 일시
     */
    private Date joinDt;
}
