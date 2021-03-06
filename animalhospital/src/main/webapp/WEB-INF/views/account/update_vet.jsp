<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type='text/javascript'>
// 모달창 검색어 검색 필터
	function filter(){
		if($('#txtFilter').val()=="")
			$("#modalTableInfo tr").css('display','');			
		else{
			$("#modalTableInfo tr").css('display','none');
			$("#modalTableInfo tr[name*='"+$('#txtFilter').val().toLowerCase()+"']").css('display','');
		}
		return false;
	}
	function checkList(){
		if($("#vetTel").val().length<10){
			alert("전화번호를 제대로 입력해 주세요");
			return false;
		 }else{
			$("#vetForm").submit();
		}
	}
</script>

<script type="text/javascript">
	$(document).ready(function() {
		var vetTel=$("#vetTel").val();
		// 모달창 띄우는 함수
		$("#popbutton").click(function() {
			// 모달창이 뜨기 전에 ajax로 병원 정보를 가져온다
			$.ajax({
			    type: "post", // get 또는 post로 설정
			    url: "findAllHospitalAjax.do", // 이동할 url 설정
			    success: function(hospitalList){
			    	var tableInfo = "";
			    	$.each(hospitalList, function(index) {
			    		tableInfo += "<tr class='odd pointer' name="+ hospitalList[index].hospitalName.toLowerCase() +">";
			    		tableInfo += "<td>" + hospitalList[index].hospitalId +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalName +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalAddress +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalTel +"</td>";
			    		tableInfo += "<td> " + 
			    					" <button type='button' class='btn btn-info' " +
			    					"name='selectHospitalBtn'>선택</button>" +
			    					"</td>";
			    		tableInfo += "</tr>";
					});
			    	$("#modalTableInfo").html(tableInfo);
			    	$("[name='selectHospitalBtn']").click(function() {
						$("#hospitalName").val($(this).parent().siblings().eq(1).text());
						$("#hospitalId").attr('value', $(this).parent().siblings().eq(0).text()); 
						$('div.modal').modal('hide');
						})
			    	
			    }
			});
			// 모달창을 띄운다
			$('div.modal').modal({
				
			});
		});

		//숫자만 입력할 수 있도록 정의
		$("#vetTel").keyup(function(){
			$(this).val( $(this).val().replace(/[^0-9]/g,""));
			if($(this).val().trim().length > 11){
				$(this).val($(this).val().replace($(this).val(),$(this).val().substring(0,11)));
				alert("전화번호 양식에 맞게 작성해주세요!");
			}else{
				if($(this).val()==vetTel){
					$("#telCheckInfo").text("전화번호가 사용가능합니다!");
					submitFlag=true;
				}else{
					$.ajax({
						url : "checkVetByTel.do",
						data : "vetTel="+ $(this).val(),
						type : "post",
						success : function(checkVetByTelResult){
							if(checkVetByTelResult==0){
								$("#telCheckInfo").text("전화번호가 사용가능합니다!");
								$("#telCheckInfo").attr('class', 'text-primary');
								submitFlag=true;
							}else{
								$("#telCheckInfo").text("이미 존재하는 전화번호입니다");
								$("#telCheckInfo").attr('class', 'text-danger');
								submitFlag=false;
							}
						}
					});
				}
			}
		});
		
	});
</script>    
<div class="x_panel">
      <div class="x_title">
        <h2>수의사 회원정보수정
        </h2>
        <ul class="nav navbar-right panel_toolbox">
          <li></li>
        </ul>
        <div class="clearfix"></div>
      </div>
      <div class="x_content">
        <br>
        <form id="vetForm" class="form-horizontal form-label-left" action="updateVet.do" method="post">
          <div class="form-group">
            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="occupation">아이디
              <span class="required">*</span>
            </label>
            <div class="col-md-4 col-sm-6 col-xs-12">
            	<!-- 수의사 id에 대한 input -->
            	<input type="text" id="vetId" class="form-control col-md-7 col-xs-12"
              	name="vetList[0].vetId" value="${sessionScope.loginVO.vetList[0].vetId }"required readonly/>
              	<p class="help-block"></p>
            </div>
            <div>
            	<!-- 텍스트 색깔은 text-primary text-danger 이거 사용-->
              <h3></h3><span class="text-danger" id="idSearchMessage" style="font-weight: bold"></span>
          	</div>
          </div>
          <div class="form-group">
            <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드
              <span class="required">*</span>
            </label>
            <div class="col-md-4 col-sm-6 col-xs-12">
            	<!-- 수의사 password에 대한 input -->
              	<input type="password" id="vetPassword" required="required" class="form-control col-md-7 col-xs-12"
              	name="vetList[0].vetPassword">
            </div>
          </div>
          <div class="form-group">
            <label class="control-label col-md-3 col-sm-3 col-xs-12">전화번호
              <span class="required">*</span>
            </label>
            <div class="col-md-4 col-sm-6 col-xs-12">
            	<!-- 수의사 tel에 대한 input -->
              	<input type="text" id="vetTel" required="required" class="form-control col-md-7 col-xs-12"
              	name="vetList[0].vetTel"  value="${sessionScope.loginVO.vetList[0].vetTel}">
            </div>
            <div>
            	<!-- 텍스트 색깔은 text-primary -->
              <span class="text-primary" id="telCheckInfo" style="font-weight: bold">
              	전화번호는 특수기호를 빼고 넣어주세요<br>
              	ex) 01020433456
              </span>
          	</div>
          </div>
          <div class="form-group">
            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">면허증번호
              <span class="required">*</span>
            </label>
            <div class="col-md-4 col-sm-6 col-xs-12">
            	<!-- 수의사 면허증 번호에 대한 input -->
              	<input type="text" id="vetLicenseNo" required="required" 
              	class="form-control col-md-7 col-xs-10" value="${sessionScope.loginVO.vetList[0].vetLicenseVO.vetLicenseNo}"
              	name="vetList[0].vetLicenseVO.vetLicenseNo" readonly>
            </div>
            <div>
              <h3></h3>
              <span class="text-danger" id="licenseSearchMessage" style="font-weight: bold"></span>
              </div>
          	</div>
          <div class="form-group">
            <label for="last-name" class="control-label col-md-3 col-sm-3 col-xs-12">이름
              <span class="required">*</span>
            </label>
            <div class="col-md-2 col-sm-6 col-xs-12">
            	<!-- 수의사 이름에 대한 input -->
              	<input id="vetName" class="form-control col-md-7 col-xs-10 test" type="text" name="vetList[0].vetLicenseVO.vetName" value="${sessionScope.loginVO.vetList[0].vetLicenseVO.vetName}" 
              	required="required" readonly>
            </div>
          </div>
          <div class="form-group">
            <label for="last-name" class="control-label col-md-3 col-sm-3 col-xs-12">병원이름
              <span class="required">*</span>
            </label>
            <div class="col-md-2 col-sm-6 col-xs-12">
            	<!-- 병원 이름에 대한 input -->
              	<input id="hospitalName" class="form-control col-md-7 col-xs-10 test" type="text" name="hospitalName"
              	required="required" value="${sessionScope.loginVO.hospitalName}" readonly >
            </div>
            <input type="hidden" name="hospitalId" id="hospitalId" value="${sessionScope.loginVO.hospitalId}" required="required">
            <div>
              <button type="button" class="btn btn-info" id="popbutton">조회</button>
            </div>
            <div class="ln_solid"></div>
            <div class="form-group">
              <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
              	<!-- 등록과 취소 버튼 -->
                <button type="button" class="btn btn-success" onclick="return checkList()">등록</button>
                <button type="button" class="btn btn-primary" onClick="location.href='home.do'">취소</button>
              </div>
            </div>
          </div>
   		</form>
      </div>
    </div>  
    <!-- Modal Page -->
	<div class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					검색: <input type='text' id='txtFilter' class="form-control" 
					  		onkeyup='{filter();return false}' 
					  		onkeypress='javascript:if(event.keyCode==13){ filter(); return false;}'>
				</div>
				<div class="modal-body">
					<table 	class="table table-striped responsive-utilities jambo_table bulk_action" id=modalTable>
				<thead>
				<tr class="headings">
					<th class="column-title">No</th>
					<th class="column-title">병원명</th>
					<th class="column-title">주소</th>
					<th class="column-title">전화번호</th>
					<th class="column-title">선택</th>
				</tr>
			</thead>
			<tbody id="modalTableInfo">
				
			</tbody>	
			</table>
				</div>
			</div>
		</div>
	</div>
