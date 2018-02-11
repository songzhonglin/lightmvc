<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#customerEditForm').form({
			url : '${ctx}/customer/edit',
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
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为customer.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
		$("#custSex").val('${customer.custSex}');
		$("#remark").val('${customer.remark}');
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<form id="customerEditForm" method="post" enctype="multipart/form-data">
			<table class="grid">
				<tr>
					<td style="width: 130px;">姓名:</td>
					<td style="width: 130px;">
						<input name="id" type="hidden"  value="${customer.id}">
						<input name="imgPath" type="hidden"  value="${customer.imgPath}">
						<input name="custName" type="text" class="easyui-textbox" data-options="required:true,prompt:'请输入中文',validType:['chinese','maxLength[5]']" value="${customer.custName}">
					<td style="width: 130px;">性别:</td>
					<td style="width: 130px;"><select name="custSex" class="easyui-combobox" id="custSex" data-options="required:true,validType:'selectValueRequired',width:150,editable:false,panelHeight:'auto'">
							<option value="">--请选择--</option>
							<option value="0">男</option>
							<option value="1">女</option>
					</select></td>
				</tr>
				<tr>
					<td>联系方式:</td>
					<td>
						<input type="text" value="${customer.custPhone}" name="custPhone" class="easyui-textbox" data-options="required:true,prompt:'请输入正确的联系方式',validType:'telNum'" />
					</td>
					<td>年龄:</td>
					<td>
						<input type="text" name="custAge" class="easyui-numberbox" data-options="required:true,prompt:'请输入正确的年龄',validType:'age'" value="${customer.custAge}"/>
					</td>
				</tr>
				<tr>
					<td>身份证号码:</td>
					<td>
						<input type="text" name="idCard" class="easyui-numberbox" value="${customer.idCard}"/>
					</td>
					<td>微信号:</td>
					<td><input class="easyui-textbox" name="custWebchat" value="${customer.custWebchat}"/></td>
				</tr>
				<tr>
					<td>QQ号:</td>
					<td>
						<input name="custQq" class="easyui-numberbox" value="${customer.custQq}"/>
					</td>
					<td>邮箱:</td>
					<td><input class="easyui-textbox" name="custEmail" data-options="validType:'email'"/></td>
				</tr>
				<tr>
					<td>地址:</td>
					<td colspan="3">
						<input type="text" class="easyui-textbox" name="custAddress" data-options="width:332" value="${customer.custAddress}"/>
					</td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
						<input class="easyui-textbox" name="remark" id="remark" data-options="multiline:true" style="width:332px;height:40px">
					</td>
				</tr>
				<tr>
					<td>
						个人图片:
					</td>
					<td colspan="3">
						<input type="file" name="sourceFile">
				   </td> 
				</tr>
				<tr>
					<td colspan="4" style="text-align: center;">
						<img alt="" src="${ctx}/${customer.imgPath}" style="height: 140px;" />
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>