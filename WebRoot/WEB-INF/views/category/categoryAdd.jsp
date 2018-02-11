<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {

		$('#categoryAddForm').form({
			url : '${pageContext.request.contextPath}/category/add',
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
		<form id="categoryAddForm" method="post">
			<table class="grid">
				<tr>
					<td style="width: 130px;">品类编码:</td>
					<td style="width: 130px;">
						<input name="categoryCode" class="easyui-textbox" data-options="required:true,prompt:'请输入品类编码',validType:'english'" value="">
					</td>
					<td style="width: 130px;">品类名称:</td>
					<td style="width: 130px;">
						<input name="categoryName" class="easyui-textbox" data-options="required:true,prompt:'请输入品类名称',validType:'chinese'" value="">
					</td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
						<input class="easyui-textbox" name="remark" data-options="multiline:true" style="width:332px;height:40px">
					</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>