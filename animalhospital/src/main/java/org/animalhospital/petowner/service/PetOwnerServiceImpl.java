package org.animalhospital.petowner.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.animalhospital.petowner.model.DAO.PetOwnerDAO;
import org.animalhospital.petowner.model.VO.PetOwnerVO;
import org.springframework.stereotype.Service;

@Service
public class PetOwnerServiceImpl implements PetOwnerService {
	@Resource
	private PetOwnerDAO petOwnerDAO;

	@Override
	public PetOwnerVO loginPetOwner(PetOwnerVO povo) {
		return petOwnerDAO.loginPetOwner(povo);
	}

	@Override
	public void updatePetOwner(PetOwnerVO povo) {
		petOwnerDAO.updatePetOwner(povo);
	}
	@Override
	public String telCheckPetOwner(PetOwnerVO povo) {
		PetOwnerVO telCheckedpovo = petOwnerDAO.telCheckPetOwner(povo);
		String flag = "fail";
		if(telCheckedpovo != null) {
			if(telCheckedpovo.getPetOwnerTel() != null)
				flag = "fail";
			if(telCheckedpovo.getPetOwnerId() == null) {
				flag = "ok_update";
			}
		} else 
			flag = "ok";
		return flag;
	}
	

	@Override
	public void registerPetOwner(PetOwnerVO povo) {
		petOwnerDAO.registerPetOwner(povo);
		HashMap<String, Object> pom = new HashMap<String, Object>();
		pom.put("petOwnerNo", povo.getPetOwnerNo());
		if(povo.getPetVO()!=null) {
			for(int i=0; i<povo.getPetVO().size(); i++) {
				pom.put("petVO", povo.getPetVO().get(i));
				petOwnerDAO.registerPet(pom);
			}
		}
	}
	
	@Override
	public void registerPet(PetOwnerVO povo) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		System.out.println(povo);
		map.put("petOwnerNo", povo.getPetOwnerNo());
		if(povo.getPetVO()!=null) {
			for(int i=0; i<povo.getPetVO().size(); i++) {
				map.put("petVO", povo.getPetVO().get(i));
				petOwnerDAO.registerPet(map);
			}
		}
	}

	@Override
	public PetOwnerVO findPetListByTel(PetOwnerVO povo) {
		return petOwnerDAO.findPetListByTel(povo);
	}
	public PetOwnerVO findPetListByPetownerTel(String petOwnerTel){
		return petOwnerDAO.findPetListByPetownerTel(petOwnerTel);
	}

	@Override
	public String findPetOwnerById(PetOwnerVO povo) {
		return petOwnerDAO.findPetOwnerById(povo)==0 ? "ok" : "fail";
	}

	@Override
	public void registerPetOwnerByTel(PetOwnerVO povo) {
		petOwnerDAO.registerPetOwnerByTel(povo);
		HashMap<String, Object> pom = new HashMap<String, Object>();
		pom.put("petOwnerNo", petOwnerDAO.loginPetOwner(povo).getPetOwnerNo());
		if(povo.getPetVO()!=null) {
			for(int i=0; i<povo.getPetVO().size(); i++) {
				pom.put("petVO", povo.getPetVO().get(i));
				petOwnerDAO.registerPet(pom);
			}
		}
	}
	
	
}
