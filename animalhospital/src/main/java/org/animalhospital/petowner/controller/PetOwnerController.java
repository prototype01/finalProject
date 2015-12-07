package org.animalhospital.petowner.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.animalhospital.petowner.model.VO.PetOwnerVO;
import org.animalhospital.petowner.service.PetOwnerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class PetOwnerController {
	@Resource
	private PetOwnerService petOwnerService;
	
	/**
	 * 보호자 진료조회 페이지
	 * @return
	 */
	@RequestMapping("viewTreatmentRecordPage.do")
	public ModelAndView viewFindPetOwnerTreatmentRecord(HttpServletRequest request){
		HttpSession session = 	request.getSession(false);
		PetOwnerVO vo = null;
		if(session != null){
			vo = (PetOwnerVO) session.getAttribute("loginVO");
		} else {
			// 세션이 끊어졌을 시에는 처리할 조건을 걸어줘야 함
			// exception: SessionNotFoundException
			// 예외처리를 AOP로 처리함, 단계에 대한 고민이 필요함, info 단계로 예상, 민호
		}
		return new ModelAndView("find_petOwner_treatmentRecord", "findPetResult",
				petOwnerService.findPetOwnerByTel(vo));
	}
	
	
	/**
	 * 보호자 로그인
	 * userLevel로 수의사와 보호자를 구분한다
	 * 수의사 userLevel = "vet"
	 * @param request
	 * @param povo
	 * @return
	 */
	@RequestMapping(value = "loginPetOwner.do", method = RequestMethod.POST)
	public String loginPetOwner(HttpServletRequest request, PetOwnerVO povo){
		PetOwnerVO petOwnerVO = petOwnerService.loginPetOwner(povo);
		if (petOwnerVO != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loginVO", petOwnerVO);
			session.setAttribute("userLevel", "petOwner");
			return "home";
		} else {
			return "account/login_fail";
		}
	}
	@RequestMapping("logout.do")
	public String logout(HttpServletRequest request){
		HttpSession session = request.getSession(false);
		if (session != null)
			session.invalidate();
		return "index";
	}
	
	@RequestMapping(value = "registerPetOwner.do", method = RequestMethod.POST)
	public String register(PetOwnerVO povo) {
		petOwnerService.registerPetOwner(povo);		
		return "redirect:registerPetOwnerResult.do?" + povo.getPetOwnerId();
	}
	
	@RequestMapping(value = "updatePetOwner.do", method = RequestMethod.POST)
	public String updatePetOwner(HttpServletRequest request, PetOwnerVO povo) {
		HttpSession session = request.getSession(false);
		String path = "redirect:login";
		if (session != null) {
			petOwnerService.updatePetOwner(povo);
			session.setAttribute("povo", povo);
			path = "redirect:update_result";
		}
		return path;
	} 
	
}
