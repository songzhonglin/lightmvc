<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		
		$('#categoryId').combotree({
			url : '${ctx}/category/tree',
		    required: true,
		    panelHeight : 'auto',
		    value : '${kind.categoryId}'
		});
		
		$('#kindEditForm').form({
			url : '${ctx}/kind/edit',
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
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为kind.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
		$("#remark").val('${kind.remark}');
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<form id="kindEditForm" method="post" enctype="multipart/form-data">
			<table class="grid">
				<tr>
					<td style="width: 130px;">种类编码:</td>
					<td style="width: 130px;">
						<input name="id" type="hidden"  value="${kind.id}">
						<input name="kindCode" class="easyui-textbox" readonly="readonly" data-options="required:true,prompt:'请输入种类编码',validType:'english'" value="${kind.kindCode}">
					</td>
					<td style="width: 130px;">种类名称:</td>
					<td style="width: 130px;">
						<input name="kindName" class="easyui-textbox"  data-options="required:true,prompt:'请输入种类名称',validType:'chinese'" value="${kind.kindName}">
					</td>
				</tr>
				<tr>
					<td>属于品类</td>
					<td><select id="categoryId" name="categoryId" style="width: 150px;" class="easyui-validatebox" data-options="required:true"></select></td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
						<input class="easyui-textbox" id="remark" name="remark" data-options="multiline:true" style="width:332px;height:40px">
					</td>
				</tr>
				<tr>
					<td>种类图片</td>
					<td colspan="3">
						<input type="file" name="sourceFile">
					</td>
				</tr>
				<tr>
					<td colspan="4" style="text-align: center;">
						<img alt="" src="${ctx}/${kind.imgPath}" style="height: 180px;" />
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>