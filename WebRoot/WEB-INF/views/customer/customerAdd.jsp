<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {

		$('#customerAddForm').form({
			url : '${pageContext.request.contextPath}/customer/add',
			onSubmit : function() {
				progressLoad();
				var isValid = $(this).form('validate');
				if (!isValid) {
					progressClose();
				}
				return isValid;
			},
			success : function(result) {
				progressClose();
				result = $.parseJSON(result);
				if (result.success) {
					parent.$.messager.alert('提示', result.msg, 'info');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<form id="customerAddForm" method="post" enctype="multipart/form-data">
			<table class="grid">
				<tr>
					<td style="width: 130px;">姓名:</td>
					<td style="width: 130px;">
						<input name="custName" class="easyui-textbox"  data-options="required:true,prompt:'请输入中文',validType:['chinese','maxLength[5]']" value="">
					</td>
					<td style="width: 130px;">性别:</td>
					<td style="width: 130px;"><select name="custSex" class="easyui-combobox" data-options="required:true,validType:'selectValueRequired',width:150,editable:false,panelHeight:'auto'">
							<option value="">--请选择--</option>
							<option value="0">男</option>
							<option value="1" >女</option>
					</select></td>
				</tr>
				<tr>
					<td>联系方式:</td>
					<td>
						<input  name="custPhone" class="easyui-numberbox" data-options="required:true,prompt:'请输入正确的联系方式',validType:'telNum'" />
					</td>
					<td>年龄:</td>
					<td>
						<input  name="custAge" class="easyui-numberbox" data-options="required:true,prompt:'请输入正确的年龄',validType:'age'"/>
					</td>
				</tr>
				<tr>
					<td>身份证号码:</td>
					<td>
						<input  name="idCard" class="easyui-numberbox" data-options="validType:'idCard'"/>
					</td>
					<td>微信号:</td>
					<td><input  class="easyui-textbox" name="custWebchat"/></td>
				</tr>
				<tr>
					<td>QQ号:</td>
					<td>
						<input  name="custQq" class="easyui-numberbox" data-options="validType:'qq'"/>
					</td>
					<td>邮箱:</td>
					<td><input  class="easyui-textbox" name="custEmail" data-options="validType:'email'"/></td>
				</tr>
				<tr>
					<td>地址:</td>
					<td colspan="3">
						<input class="easyui-textbox" name="custAddress" style="width:332px;"/>
					</td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
<!-- 					<textarea name="remark" rows="2" cols="61" > -->
						<input class="easyui-textbox" name="remark" data-options="multiline:true" style="width:332px;height:40px">
					</td>
				</tr>
				<tr>
					<td>
						个人图片:
					</td>
					<td colspan="3">
						<input type="file" name="sourceFile">
<!-- 						<input class="easyui-filebox" name="sourceFile" data-options="prompt:'Choose a file...'" style="width:100%"> -->
				   </td> 
				</tr>
			</table>
		</form>
	</div>
</div>