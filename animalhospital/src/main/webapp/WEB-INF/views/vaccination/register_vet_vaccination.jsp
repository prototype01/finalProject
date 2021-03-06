<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<script>

	$(document).ready(function() {
		$("#petOwnerTel").keyup(function(){
			$("#selectPet").html("<option></option>");
			//보호자 전화번호값이 9자 이하인 경우
			if($("#petOwnerTel").val().length<10){
				$("#checkTel").html("전화번호입력해라");
				$("#checkTel").attr('class', 'text-danger');
			}else{
			//보호자 전화번호값이 10자 이상인 경우 전화번호를 이용하여 petList를 불러옴
				$.ajax({
					type:"post",
					data:"petOwnerTel="+$("#petOwnerTel").val(),
					url:"findPetListByPetOwnerTel.do",
					success: function(PetOwnerVO){//전화번호로 검색하여 PetOwnerVO를 가져온다.
						var petVO=PetOwnerVO.petVO;
						var result="";
						 if(PetOwnerVO == ""){
							$("#checkTel").html("정확히 입력하세요");
							$("#checkTel").attr('class','text-danger');
						}else{	//if-end ,else-begin		
							$.each(petVO, function(pi) {
								result+="<option>"+petVO[pi].petName+"</option>"
							});
							$("#checkTel").html(PetOwnerVO.petOwnerName);
							$("#checkTel").attr('class','text-primary');
							$("#petOwnerNo").attr('value', PetOwnerVO.petOwnerNo);
							$("#selectPet").append(result); 
						}//else 
					}//success
				});//ajax종료
			}
		});
		$("#cancelBtn").click(function(){
			location.href="home.do";
		});
 		$(".select2_single").select2({
			placeholder : "해당 항목을 선택해주세요",
			allowClear : true
		}); 
  		$(".select2_group").select2({});
		$(".select2_multiple").select2({
			maximumSelectionLength : 4,
			placeholder : "With Max Selection limit 4",
			allowClear : true
		});  
		
		 
	      // 백신 예방접종 차수를 등록에 추가함
	      var vaccinationMaximumSection = 0;
	      var optionInfo = "";
	      vaccinationMaximumSection = ${requestScope.VaccinationList[0].vaccinationMaximumSection }
	      for (var mi = 0; mi < vaccinationMaximumSection; mi++) {
				optionInfo += "<option value=" + (mi+1) +">" + (mi+1)+"차" + "</option>";
			}
	      optionInfo += "<option value=" + (vaccinationMaximumSection+1) +">" 
			+ "기준 차수 초과" + "</option>"
	      $("#vaccinationCurrentSection").html(optionInfo);
	      
	      
	    $("#vaccinationName").change(function() {
	    	vaccinationMaximumSection =0;
	    	optionInfo = "";
	    	<c:forEach var="vaccination" items="${requestScope.VaccinationList }">
	    		if($("#vaccinationName option:selected").text() == "${vaccination.vaccinationName }"){
	    			vaccinationMaximumSection = 	${vaccination.vaccinationMaximumSection }
	    		}
	 		</c:forEach>
	 		if (vaccinationMaximumSection == 0) {
	 			optionInfo = "<option value='0'>예방접종 기준 차수 없음</option>";
			} else {
				for (var mi = 0; mi < vaccinationMaximumSection; mi++) {
					optionInfo += "<option value=" + (mi+1) +">" + (mi+1)+"차" + "</option>";
				}
				optionInfo += "<option value=" + (vaccinationMaximumSection+1) +">" 
						+ "기준 차수 초과" + "</option>"
			}
	 		$("#vaccinationCurrentSection").html(optionInfo);
	 		
		});
	      
	      
	});
</script>
<!-- /select2 -->
<script>
	autosize($('.resizable_textarea'));
</script>

<div class="x_panel">
	<div class="x_title">
		<h2>
			예방접종등록   
		</h2>
		<div class="clearfix"></div>
	</div>
	<div class="x_content">
		  
		<!-- 폼 시작부 -->
		<form id="treatmentForm" action="registerVaccination.do" method="post">
			<label for="inputInfo">보호자 전화번호:</label> <span id="checkTel"></span>
			<input type="text" id="petOwnerTel" class="form-control" name="" required="required"/>
			<input type="hidden" id="petOwnerNo" name="petOwnerVO.petOwnerNo" >
			<input type="hidden" id="vetLicenseNo" 
			name="hospitalVO.vetList[0].vetLicenseVO.vetLicenseNo"
			value="${sessionScope.loginVO.vetList[0].vetLicenseVO.vetLicenseNo }">
			<label>반려동물 - 보호자 전화번호로 검색</label>
		 	<select class="select2_single form-control" tabindex="-1" id="selectPet" 
			 		name="petOwnerVO.petVO[0].petName" required="required">
				<option></option>
			</select>
				
			<br>
			<label for="inputInfo" >몸무게:</label> 
			<input type="text" id="petWeight" class="form-control" name="petWeight" required="required"/>
			<hr> 
			<label>예방접종종류</label> 
			<select class="select2_single form-control" name="vaccinationVO.vaccinationNo"   required="required" id="vaccinationName">
	            <c:forEach var="vaccination" items="${requestScope.VaccinationList }">
	               <option value="${vaccination.vaccinationNo }">${vaccination.vaccinationName }</option>
	            </c:forEach>
         	</select>
			
         	<br>
			<label>예방접종차수</label>
			<select class="form-control"
				name="vaccinationCurrentSection" required="required"
				id="vaccinationCurrentSection">
			</select>
			<br>
			<label>진료내용</label>
			<textarea class="form-control" rows="8" name="vaccinationContent" required="required"  placeholder="진료내용을 입력해주세요">
			</textarea>
			<div class="ln_solid"></div>
			<div class="form-group">
				<div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
					<p align="center">
						<button type="submit" class="btn btn-primary">등록</button>
						<button type="button" class="btn btn-success" id="cancelBtn">취소</button>
					</p>
				</div>
			</div>
		</form>
		<!-- end form for validations -->

	</div>
</div>

