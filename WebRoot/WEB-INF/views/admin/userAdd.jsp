<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">


	$(function() {
		
		$('#organizationId').combotree({
			url : '${ctx}/organization/tree',
			parentField : 'pid',
			lines : true,
			panelHeight : 'auto'
		});
		
		$('#roleIds').combotree({
		    url: '${ctx}/role/tree',
		    multiple: true,
		    required: true,
		    panelHeight : 'auto'
		});
		
		$('#userAddForm').form({
			url : '${ctx}/user/add',
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
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('提示', result.msg, 'warning');
				}
			}
		});
		
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<form id="userAddForm" method="post">
			<table class="grid">
				<tr>
					<td>登录名</td>
					<td><input name="loginname" class="easyui-textbox"  placeholder="请输入登录名称" class="easyui-validatebox" data-options="required:true,validType:'loginName'" value=""></td>
					<td>姓名</td>
					<td><input name="name" class="easyui-textbox"  placeholder="请输入姓名" class="easyui-validatebox" data-options="required:true,validType:'chinese'" value=""></td>
				</tr>
				<tr>
					<td>密码</td>
					<td><input name="password" type="password" placeholder="请输入密码" class="easyui-textbox" data-options="required:true,validType:'pwd'"></td>
					<td>性别</td>
					<td><select name="sex" class="easyui-combobox" data-options="width:150,editable:false,panelHeight:'auto'">
							<option value="0" selected="selected">男</option>
							<option value="1" >女</option>
					</select></td>
				</tr>
				<tr>
					<td>年龄</td>
					<td><input type="text" name="age" class="easyui-numberbox" data-options="required:true,validType:'age'"/></td>
					<td>用户类型</td>
					<td><select name="usertype" class="easyui-combobox" data-options="width:150,editable:false,panelHeight:'auto'">
							<option value="2">超级管理员</option>
							<option value="0">管理员</option>
							<option value="1" selected="selected">用户</option>
					</select></td>
				</tr>
				<tr>
					<td>部门</td>
					<td><select id="organizationId" name="organizationId" style="width: 150px;" class="easyui-validatebox" data-options="required:true"></select></td>
					<td>角色</td>
					<td><select id="roleIds"  name="roleIds"   style="width: 150px;"></select></td>
				</tr>
				<tr>
					<td>电话</td>
					<td colspan="">
						<input type="text" name="phone" class="easyui-numberbox" data-options="required:true,validType:'telNum'"/>
					</td>
					<td>用户状态</td>
					<td><select id="state" name="state" class="easyui-combobox" data-options="width:150,editable:false,panelHeight:'auto'">
							<option value="0" selected="selected">正常</option>
							<option value="1">停用</option>
					</select></td>
				</tr>
			</table>
		</form>
	</div>
</div>