<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<c:if test="${fn:contains(sessionInfo.resourceList, '/user/kitLogin')}">
	<script type="text/javascript">
		$.canKit = true;
	</script>
</c:if>

<c:if test="${fn:contains(sessionInfo.resourceList, '/msg/talk')}">
	<script type="text/javascript">
		$.canTalk = true;
	</script>
</c:if>

<title>在线用户管理</title>
	<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${ctx}' + '/user/onLineUser',
			striped : true,
			rownumbers : true,
			pagination : false,
			singleSelect : true,
			frozenColumns : [ [ {
				width : '80',
				title : 'SESSIONID',
				field : 'sessionId',
				hidden : true,
				sortable : false
			} , {
				width : '80',
				title : 'ID',
				align : 'center',
				field : 'id',
				sortable : false
			} , {
				width : '200',
				title : '名称',
				align : 'center',
				field : 'name'
			},{
				width : '200',
				title : 'IP',
				align : 'center',
				field : 'ip'
			} ,{
				width : '200',
				title : '创建时间',
				align : 'center',
				field : 'createTime'
			} ,{
				width : '200',
				title : '最近访问时间',
				align : 'center',
				field : 'LastAccessedTime'
			}, {
				field : 'action',
				title : '操作',
				align : 'center',
				width : 120,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canKit) {
					 str = $.formatString('<a href="javascript:void(0)" onclick="KitLogin(\'{0}\');" >强制下线</a>', row.id);
					 str += '&nbsp;&nbsp;&nbsp;&nbsp;';
					}
					if($.canTalk){
						str += $.formatString('<a href="javascript:void(0)" onclick="sendFun(\'{0}\');" >发送信息</a>', row.id);
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
					}
					return str;
				}
			} ] ]
		});
	});
	
	function sendFun(id){
		var currentUserId = '${sessionInfo.id}'; /*当前登录用户的ID*/
		if (currentUserId != id) {
			window.location.href="${ctx}/msg/talk?to="+id;
		}else{
			parent.$.messager.show({
				title : '提示',
				msg : '不可以给自己发送信息！'
			});
		}
	}
	
	function KitLogin(id) {
		parent.$.messager.confirm('询问', '您是否要强制当前用户下线吗？', function(b) {
			if (b) {
				var currentUserId = '${sessionInfo.id}'; /*当前登录用户的ID*/
				if (currentUserId != id) {
					progressLoad();
					$.post('${ctx}/user/kitLogin', {
						id : id
					}, function(result) {
						if (result.success) {
							parent.$.messager.alert('提示', result.msg, 'info');
							dataGrid.datagrid('reload');
						}
						progressClose();
					}, 'JSON');
				} else {
					parent.$.messager.show({
						title : '提示',
						msg : '不可以强制自己下线！'
					});
				}
			}
		});
	}
	
	</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',fit:true,border:false">
		<table id="dataGrid" data-options="fit:true,border:false"></table>
	</div>
</body>
</html>