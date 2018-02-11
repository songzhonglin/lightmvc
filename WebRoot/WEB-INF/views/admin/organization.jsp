<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<c:if test="${fn:contains(sessionInfo.resourceList, '/organization/edit')}">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/organization/delete')}">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</c:if>
<title>机构管理</title>
<script type="text/javascript">
	var treeGrid;
	$(function() {
		treeGrid = $('#treeGrid').treegrid({
			url : '${ctx}/organization/treeGrid',
			idField : 'id',
			rownumbers : true,
			treeField : 'name',
			parentField : 'pid',
			fit : true,
			fitColumns : false,
			border : false,
		/* 	frozenColumns : [ [ {
				title : '序号',
				field : 'id',
				width : 45,
				hidden : true
			} ] ], */
			columns : [ [ 
			/*               {
				field : 'code',
				title : '编号',
				align : 'center',
				width : 40
			}, */
			{
				field : 'name',
				title : '部门名称',
				align : 'center',
				width : 200
			}, {
				field : 'seq',
				title : '排序',
				align : 'center',
				width : 40
			}, {
				field : 'icon',
				title : '图标',
				align : 'center',
				width : 90
			},  {
				width : '130',
				title : '创建时间',
				align : 'center',
				field : 'createdatetime',
				formatter : function (value,row,index){
					return formatterDate(value);
				}
			},{
				field : 'pid',
				title : '上级资源ID',
				width : 150,
				hidden : true
			}, {
				field : 'address',
				title : '地址',
				halign :'center',
				align : 'left',
				width : 250
			} , {
				field : 'action',
				title : '操作',
				width : 80,
				align : 'center',
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
					}
					if ($.canDelete) {
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $.formatString('<a href="javascript:void(0)" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
					}
					return str;
				}
			} ] ],
			toolbar : '#toolbar'
		});
	});
	
	function editFun(id) {
		if (id != undefined) {
			treeGrid.treegrid('select', id);
		}
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			parent.$.modalDialog({
				title : '编辑',
				width : 500,
				height : 300,
				href : '${ctx}/organization/editPage?id=' + node.id,
				buttons : [ {
					text : '编辑',
					handler : function() {
						parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
						var f = parent.$.modalDialog.handler.find('#organizationEditForm');
						f.submit();
					}
				} ]
			});
		}
	}
	
	function deleteFun(id) {
		if (id != undefined) {
			treeGrid.treegrid('select', id);
		}
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			parent.$.messager.confirm('询问', '您是否要删除当前资源？删除当前资源会连同子资源一起删除!', function(b) {
				if (b) {
					progressLoad();
					$.post('${ctx}/organization/delete', {
						id : node.id
					}, function(result) {
						if (result.success) {
							parent.$.messager.alert('提示', result.msg, 'info');
							treeGrid.treegrid('reload');
						}else{
							parent.$.messager.alert('提示', result.msg, 'info');
						}
						progressClose();
					}, 'JSON');
				}
			});
		}
	}
	
	function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 500,
			height : 300,
			href : '${ctx}/organization/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#organizationAddForm');
					f.submit();
				}
			} ]
		});
	}
	
	function searchFun() {
		$('#treeGrid').treegrid('load',$.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		$('#treeGrid').treegrid('load',{});
	}
	</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',border:false,title:'过滤条件'" style="height: 60px; overflow: hidden;background-color: #F0F0F0">
		<div>
			<form id="searchForm">
				<table>
					<tr>
						<td>部门名称:</td>
						<td>
							<input name="name" placeholder="请输入部门名称"/>
						</td>
						<td>
							<c:if test="${fn:contains(sessionInfo.resourceList, '/organization/treeGrid')}">
								<c:if test="${fn:contains(sessionInfo.resourceList, '/organization/treeGrid/0')}">
									<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a>
								</c:if>
							</c:if>
							<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="cleanFun();">清空</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
		<div data-options="region:'center',border:false"  style="overflow: hidden;">
			<table id="treeGrid"></table>
		</div>
		
		<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/organization/add')}">
			<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
		</c:if>
	</div>
	</div>
</body>
</html>