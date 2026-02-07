package com.bnsy.bot.controller;

import com.bnsy.bot.dto.MemberDTO;
import com.bnsy.bot.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

/**
 * 메인 페이지 컨트롤러
 * 
 * @author BNSY Team
 * @since 1.0.0
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final MemberService memberService;

    /**
     * 메인 페이지
     * 
     * @return 메인 JSP 뷰 이름 ("BNSY_main")
     */
    @GetMapping("/")
    public String main() {
        log.info("메인 웰컴 페이지 접속");
        return "BNSY_main";
    }

    /**
     * 채팅 페이지
     * 
     * @param session            사용자 세션
     * @param model              뷰 모델
     * @param redirectAttributes 리다이렉트 메시지
     * @return 채팅 JSP 뷰 이름 ("chat_main") 또는 메인 페이지로 리다이렉트
     */
    @GetMapping("/chat")
    public String chat(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        log.info("채팅 페이지 접속 시도");

        // 로그인 체크
        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            log.warn("비로그인 사용자의 채팅 페이지 접근 시도");
            redirectAttributes.addFlashAttribute("message", "로그인이 필요한 서비스입니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/";
        }

        // JSP에서 사용할 수 있도록 모델에 추가
        model.addAttribute("loginMember", loginMember);

        log.info("채팅 페이지 접속 성공: {}", loginMember.getMemberId());
        return "chat_main";
    }

    /**
     * 회원가입
     * 
     * @param memberDTO          회원가입 폼 데이터 (memberId, memberPw, memberName)
     * @param redirectAttributes 리다이렉트 시 전달할 메시지
     * @return 메인 페이지로 리다이렉트
     */
    @PostMapping("/register")
    public String register(MemberDTO memberDTO, RedirectAttributes redirectAttributes) {
        log.info("회원가입 요청: {}", memberDTO.getMemberId());

        // 회원가입 처리 (내부에서 ID 중복 체크 수행)
        boolean success = memberService.registerMember(memberDTO);

        if (success) {
            log.info("회원가입 성공: {}", memberDTO.getMemberId());
            redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다!");
            redirectAttributes.addFlashAttribute("messageType", "success");
        } else {
            log.warn("회원가입 실패: ID 중복 - {}", memberDTO.getMemberId());
            redirectAttributes.addFlashAttribute("message", "이미 존재하는 아이디입니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }

        // 메인 페이지로 리다이렉트 (입력값 초기화)
        return "redirect:/";
    }

    /**
     * 로그인
     * 
     * @param memberId           로그인 ID
     * @param memberPw           로그인 비밀번호
     * @param session            사용자 세션
     * @param redirectAttributes 리다이렉트 메시지
     * @return 성공 시 채팅 페이지로 리다이렉트, 실패 시 메인 페이지로 리다이렉트
     */
    @PostMapping("/login")
    public String login(String memberId, String memberPw,
            HttpSession session, RedirectAttributes redirectAttributes) {
        log.info("로그인 요청: {}", memberId);

        // 로그인 처리
        MemberDTO member = memberService.login(memberId, memberPw);

        if (member != null) {
            // 로그인 성공: 세션에 사용자 정보 저장
            session.setAttribute("loginMember", member);
            log.info("로그인 성공: {} ({})", member.getMemberId(), member.getMemberName());
            return "redirect:/chat";
        } else {
            // 로그인 실패
            log.warn("로그인 실패: ID 또는 비밀번호 불일치 - {}", memberId);
            redirectAttributes.addFlashAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/";
        }
    }

    /**
     * 로그아웃
     * 
     * @param session            사용자 세션
     * @param redirectAttributes 리다이렉트 메시지
     * @return 메인 페이지로 리다이렉트
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");

        if (loginMember != null) {
            log.info("로그아웃: {}", loginMember.getMemberId());
        }

        // 세션 무효화
        session.invalidate();

        redirectAttributes.addFlashAttribute("message", "로그아웃되었습니다.");
        redirectAttributes.addFlashAttribute("messageType", "success");
        return "redirect:/";
    }
}
