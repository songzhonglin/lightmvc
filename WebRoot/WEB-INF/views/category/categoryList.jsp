<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <jsp:include page="../inc.jsp"></jsp:include>
	<meta http-equiv="X-UA-Compatible" content="edge" />
	<c:if test="${fn:contains(sessionInfo.resourceList, '/category/edit')}">
		<script type="text/javascript">
			$.canEdit = true;
		</script>
	</c:if>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/category/delete')}">
		<script type="text/javascript">
			$.canDelete = true;
		</script>
	</c:if>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/category/view')}">
		<script type="text/javascript">
			$.canView = true;
		</script>
	</c:if>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/view')}">
		<script type="text/javascript">
			$.canKindView = true;
		</script>
	</c:if>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',border:false,title:'过滤条件'" style="height: 60px;background-color: #F0F0F0">
			<div>
				<form id="searchForm">
					<table>
						<tr>
							<td>品类名称:</td>
							<td><input name="categoryName" id="categoryName" class="easyui-textbox" data-options="prompt:'请输入品类名称'"/></td>
							<td><c:if
									test="${fn:contains(sessionInfo.resourceList, '/category/dataGrid')}">
									<c:if
										test="${fn:contains(sessionInfo.resourceList, '/category/dataGrid/0')}">
										<a href="javascript:void(0);" class="easyui-linkbutton"
											data-options="iconCls:'icon-search',plain:true"
											onclick="searchFun();">查询</a>
									</c:if>
								</c:if> <a href="javascript:void(0);" class="easyui-linkbutton"
								data-options="iconCls:'icon-cancel',plain:true"
								onclick="cleanFun();">清空</a></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
    	<div data-options="region:'center',border:true">
	    	<table id="dg" 
	            url="${ctx}/category/dataGrid" 
	            singleSelect="true" fitColumns="false"
	            data-options="fit:true,border:false">
	        <thead>
	            <tr>
<!-- 	                <th field="id" width="40" align="center">编号</th> -->
	                <th field="categoryCode" width="100" align="center">品类编码</th>
	                <th field="categoryName" align="center" width="110">品类名称</th>
	                <th field="creater" align="center" width="110">创建人</th>
	                <th field="remark" width="200">备注</th>
	                <th field="action" width="120" align="center" formatter="operation">操作</th>
	            </tr>
	        </thead>
	    </table>
    </div>
    <div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/category/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/category/add/0')}">
				<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/category/delete')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/category/delete/0')}">
				<a onclick="deleteBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-del'">删除</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/category/edit')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/category/edit/0')}">
				<a onclick="editBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">编辑</a>
			</c:if>
		</c:if>
	</div>
    <script type="text/javascript">
    var dataGrid;
        $(function(){
           dataGrid = $('#dg').datagrid({
	            pagination : true,
	            rownumbers:true,
				pageSize : 50,
				pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
                view: detailview,
                detailFormatter:function(index,row){
                    return '<div style="padding:2px"><table class="ddv"></table></div>';
                },
                onExpandRow: function(index,row){
                    var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
                    ddv.datagrid({
                        url:'${ctx}/kind/queryById?categoryId='+row.id,
                        fitColumns:true,
                        singleSelect:true,
                        rownumbers:true,
                        loadMsg:'',
                        height:'auto',
                        columns:[[
//                             {field:'id',title:'编号',hidden:'true',width:20},
                            {field:'kindCode',title:'种类编码',width:90,align:'center'},
                            {field:'kindName',title:'种类名称',width:100,align:'center'},
                            {field:'creater',title:'创建人',width:100,align:'center'},
                            {field:'createTime',title:'创建时间',width:130,align:'center'},
                            {field:'remark',title:'备注',width:200,align:''},
                            {field:'action',title:'操作',width:40,align:'center',formatter:function(index,row){
                            	var str = '';
								if ($.canKindView) {
									str += '&nbsp;&nbsp;&nbsp;&nbsp;';
									str += $.formatString('<a href="javascript:void(0)" onclick="viewKindFun(\'{0}\');" >查看</a>', row.id);
								}
								return str;
                            }}
                        ]],
                        onResize:function(){
                            $('#dg').datagrid('fixDetailRowHeight',index);
                        },
                        onLoadSuccess:function(){
                            setTimeout(function(){
                                $('#dg').datagrid('fixDetailRowHeight',index);
                            },0);
                        }
                    });
                    $('#dg').datagrid('fixDetailRowHeight',index);
                },
                toolbar : '#toolbar'
            });
        });
        
        function operation(val,row){
	    	var str = '&nbsp;';
				if ($.canView) {
					str += $.formatString('<a href="javascript:void(0)" onclick="viewFun(\'{0}\');" >查看</a>', row.id);
				}
				if ($.canEdit) {
					str += '&nbsp;&nbsp;';
					str += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
				}
				if ($.canDelete) {
					str += '&nbsp;&nbsp;';
					str += $.formatString('<a href="javascript:void(0)" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
				}
			return str;
        }
        
        function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 500,
			height : 160,
			href : '${ctx}/category/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#categoryAddForm');
					f.submit();
				}
			} ]
		});
	}
	
	function deleteFun(id) {
		if (id == undefined) {//点击右键菜单才会触发这个
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {//点击操作里面的删除图标会触发这个
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.messager.confirm('询问', '您是否要删除当前品类信息？', function(b) {
			if (b) {
				progressLoad();
				$.post('${ctx}/category/delete', {
					id : id
				}, function(result) {
					if (result.success) {
						parent.$.messager.alert('提示', result.msg, 'info');
						dataGrid.datagrid('reload');
					}
					progressClose();
				}, 'JSON');
			}
		});
	}
	
	function deleteBtn(){
		var rows = dataGrid.datagrid('getSelections');
		if(rows.length <= 0){
		 	$.messager.alert("提示", "请选择其中一行，再删除！","info");
		}else{
			parent.$.messager.confirm('询问', '您是否要删除当前品类信息？', function(b) {
				if (b) {
					progressLoad();
					$.post('${ctx}/category/delete', {
						id : rows[0].id
					}, function(result) {
						if (result.success) {
							parent.$.messager.alert('提示', result.msg, 'info');
// 							dataGrid.datagrid('reload');
							$('#dg').datagrid('load');
						}
						progressClose();
					}, 'JSON');
				}
			});
		}
	}
	
	function editBtn(){
		var rows = dataGrid.datagrid('getSelections');
		if(rows.length <= 0){
		 	$.messager.alert("提示", "请选择其中一行，再编辑！","info");
		}else{
			parent.$.modalDialog({
			title : '编辑',
			width : 500,
			height : 160,
			href : '${ctx}/category/editPage?id=' + rows[0].id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#categoryEditForm');
					f.submit();
				}
			} ]
		});
		}
	}
	
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.modalDialog({
			title : '编辑',
			width : 500,
			height : 160,
			href : '${ctx}/category/editPage?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#categoryEditForm');
					f.submit();
				}
			} ]
		});
	}
	
	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		
		parent.$.modalDialog({
			title : '详情',
			width : 500,
			height : 140,
			href : '${ctx}/category/viewPage?id=' + id
		});
	}
	
	function viewKindFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		
		parent.$.modalDialog({
			title : '详情',
			width : 535,
			height : 370,
			href : '${ctx}/kind/viewPage?id=' + id
		});
	}
	
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
    </script>
    
    
</body>
</html>