<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- Meta, title, CSS, favicons, etc. -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>수의사 회원가입</title>
<!-- Bootstrap core CSS -->
<link href="${initparam.root}resources/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${initparam.root}resources/fonts/css/font-awesome.min.css"
	rel="stylesheet">
<link href="${initparam.root}resources/css/animate.min.css"
	rel="stylesheet">
<!-- Custom styling plus plugins -->
<link href="${initparam.root}resources/css/custom.css" rel="stylesheet">
<link href="${initparam.root}resources/css/icheck/flat/green.css"
	rel="stylesheet">
<%-- <script src="${initparam.root}resources/js/input_mask/jquery.inputmask.js"></script> --%>
<script src="${initparam.root}resources/js/jquery.min.js"></script>
<!-- Bootstrap Core JavaScript -->
<script src="${initparam.root}resources/js/bootstrap.min.js"></script>
<!-- 유효성 검증 플러그인 -->
<script src="${initparam.root}resources//js/jqBootstrapValidation.js"></script>
<!-- 유효성 검증 플러그인 적용 -->
<script>
  $(function () { $("input,select,textarea").not("[type=submit]").jqBootstrapValidation(); } );
</script>

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
</script>

<script type="text/javascript">
	var submitFlag = false;

	$(document).ready(function() {
		$("#cancleBtn").click(function(){
			if(confirm("회원 가입을 취소하시겠습니까?")){
				location.href="home.do";
			}
		});
		// 모달창 띄우는 함수
		$("#popbutton").click(function() {
			submitFlag = false;
			// 모달창이 뜨기 전에 ajax로 병원 정보를 가져온다
			$.ajax({
			    type: "post", // get 또는 post로 설정
			    url: "findAllHospitalAjax.do", // 이동할 url 설정
			    success: function(hospitalList){
			    	var tableInfo = "";
			    	$.each(hospitalList, function(index) {
			    		tableInfo += "<tr class='odd pointer' name="
			                   + hospitalList[index].hospitalName.toLowerCase().replace(/ /g, '') +">";
			    		tableInfo += "<td>" + hospitalList[index].hospitalId +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalName +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalAddress +"</td>";
			    		tableInfo += "<td>" + hospitalList[index].hospitalTel +"</td>";
			    		tableInfo += "<td> " + 
			    					" <button type='button' class='btn btn-info' " +
			    					"name='selectHospitalBtn'>선택</button>" +
			    					"</td>";
			    		tableInfo += "</tr>";
			    		submitFlag = true;
					});
			    	$("#modalTableInfo").html(tableInfo);
			    	$("[name='selectHospitalBtn']").click(function() {
						$("#hospitalName").val($(this).parent().siblings().eq(1).text());
						$("#hospitalId").attr('value', $(this).parent().siblings().eq(0).text()); 
						$('div.modal').modal('hide');
					});
			    	
			    }
			});
			// 모달창을 띄운다
			$('div.modal').modal({
				
			});

		});
		
		
		
		// ajax를 이용하여 id의 중복체크를 한다.
		$("#vetId").keyup(function() {
			$.ajax({
			    type: "post", // get 또는 post로 설정
			    url: "findVetById.do", // 이동할 url 설정
			    data: "vetId=" + $(this).val(),
			    success: function(searchResult){
			   		if(searchResult == 0){
			   			$("#idSearchMessage").text("사용하지 않은 아이디입니다!");
			   			$("#idSearchMessage").attr('class', 'text-primary');
			   			submitFlag = true;
			   		} else {
			   			$("#idSearchMessage").text("이미 사용하고 있는 아이디입니다!");
			   			$("#idSearchMessage").attr('class', 'text-danger');
			   			submitFlag = false;
			   		}
			    }
			});
		});
		
		// ajax를 이용하여 면허증과 이름을 체크한다.	
			$("#vetLicenseNo, #vetName").keyup(function() {
				$.ajax({
				    type: "post", 
				    url: "checkVetLicense.do", 
				    data: "vetLicenseNo=" + $("#vetLicenseNo").val() + "&vetName=" + $("#vetName").val(),
				    success: function(searchResult){
				   		if(searchResult == "fail"){
				   			$("#licenseSearchMessage").text("면허번호와 이름이 일치하지 않거나 이미 사용하고 있는 면허번호입니다!");
				   			$("#licenseSearchMessage").attr('class', 'text-danger');
				   			submitFlag = false;
				   		} else {
				   			$("#licenseSearchMessage").text("면허증 번호와 이름이 일치합니다!");
				   			$("#licenseSearchMessage").attr('class', 'text-primary');
				   			submitFlag = true;
				   		}
				    }
				});
			});
		
		
		
		//숫자만 입력할 수 있도록 정의
		$("#vetTel").keyup(function(){
			$(this).val( $(this).val().replace(/[^0-9]/g,""));
			if($(this).val().length > 11){
				$(this).val($(this).val().replace($(this).val(),$(this).val().substring(0,11)));
				alert("전화번호 양식에 맞게 작성해주세요!");
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
		});
		
		// 면허증번호 숫자만 입력하기
		$("#vetLicenseNo").keyup(function(){
			$(this).val( $(this).val().replace(/[^0-9]/g,""));
			
		});
		
		// submit 제어
		$("#vetForm").submit(function() {
			return 	submitFlag;
		});
		
	});
</script>



</head>

<body style="background: #F7F7F7;">
	<div class="">
		<a class="hiddenanchor" id="toregister"></a> <a class="hiddenanchor"
			id="tologin"></a>
		<div id="wrapper">
			<div id="login" class="animate form"></div>
			<div id="register" class="animate form"></div>
		</div>
	</div>
	<div class="x_panel">
		<div class="x_title">
			<h2>수의사 회원가입</h2>
			<ul class="nav navbar-right panel_toolbox">
				<li></li>
			</ul>
			<div class="clearfix"></div>
		</div>
		<div class="x_content">
			<br>
			<form id="vetForm" class="form-horizontal form-label-left"
				action="registerVet.do" method="post" enctype="multipart/form-data">
				<div class="form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12"
						for="occupation"><span class="required">* </span>아이디 
					</label>
					<div class="col-md-4 col-sm-6 col-xs-12">
						<!-- 수의사 id에 대한 input -->
						<input type="text" id="vetId"
							class="form-control col-md-7 col-xs-12" name="vetList[0].vetId"
							required />
						<p class="help-block"></p>
					</div>
					<div>
						<!-- 텍스트 색깔은 text-primary text-danger 이거 사용-->
						<h3></h3>
						<span class="text-danger" id="idSearchMessage"
							style="font-weight: bold"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12"><span class="required">* </span>패스워드
					</label>
					<div class="col-md-4 col-sm-6 col-xs-12">
						<!-- 수의사 password에 대한 input -->
						<input type="password" id="vetPassword" required="required"
							class="form-control col-md-7 col-xs-12"
							name="vetList[0].vetPassword">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12"><span class="required">* </span>전화번호
					</label>
					<div class="col-md-4 col-sm-6 col-xs-12">
						<!-- 수의사 tel에 대한 input -->
						<input type="text" id="vetTel" required="required"
							class="form-control col-md-7 col-xs-12" name="vetList[0].vetTel">
					</div>
					<div>
						<!-- 텍스트 색깔은 text-primary -->
						<span class="text-primary" style="font-weight: bold" id="telCheckInfo"> 전화번호는
							특수기호를 빼고 넣어주세요<br> ex) 01020433456
						</span>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12"
						for="last-name"><span class="required">* </span>면허증번호
					</label>
					<div class="col-md-4 col-sm-6 col-xs-12">
						<!-- 수의사 면허증 번호에 대한 input -->
						<input type="text" id="vetLicenseNo" required="required"
							class="form-control col-md-7 col-xs-10"
							placeholder="면허증 번호와 이름을 입력해주세요"
							name="vetList[0].vetLicenseVO.vetLicenseNo">
					</div>
					<div>
						<h3></h3>
						<span class="text-danger" id="licenseSearchMessage"
							style="font-weight: bold"></span>
					</div>
				</div>
				<div class="form-group">
					<label for="last-name"
						class="control-label col-md-3 col-sm-3 col-xs-12"><span class="required">* </span>이름 
					</label>
					<div class="col-md-2 col-sm-6 col-xs-12">
						<!-- 수의사 이름에 대한 input -->
						<input id="vetName" class="form-control col-md-7 col-xs-10 test"
							type="text" name="vetList[0].vetLicenseVO.vetLicenseNo.vetName"
							required="required">
					</div>
				</div>
				<div class="form-group">
					<label for="last-name"
						class="control-label col-md-3 col-sm-3 col-xs-12"><span class="required">* </span>병원이름 
					</label>
					<div class="col-md-2 col-sm-6 col-xs-12">
						<!-- 병원 이름에 대한 input -->
						<input id="hospitalName"
							class="form-control col-md-7 col-xs-10 test" type="text"
							name="hospitalName" required="required" readonly>
					</div>
					<input type="hidden" name="hospitalId" id="hospitalId" value="">
					<div>
						<button type="button" class="btn btn-info" id="popbutton">조회</button>
					</div>
					<div class="form-group">
						<label for="last-name"
							class="control-label col-md-3 col-sm-3 col-xs-12">사진 
						</label>
						<div class="col-md-2 col-sm-6 col-xs-12">
							<!-- 수의사 이름에 대한 input -->
							<input id="imgFile"  type="file" name="" >
						</div>
					</div>
					<div class="ln_solid"></div>
					<div class="form-group">
						<div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
							<!-- 등록과 취소 버튼 -->
							<button type="submit" class="btn btn-success">등록</button>
							<button type="button" class="btn btn-primary" id="cancleBtn">취소</button>
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
					<button type="button" class="close" id="dismiss"
						name="selectHospitalBtn" aria-hidden="true" data-dismiss="modal">×</button>
					검색: <input type='text' id='txtFilter' class="form-control"
						onkeyup='{filter();return false}'
						onkeypress='javascript:if(event.keyCode==13){ filter(); return false;}'>
				</div>
				<div class="modal-body">
					<table
						class="table table-striped responsive-utilities jambo_table bulk_action"
						id=modalTable>
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
</body>

</html>