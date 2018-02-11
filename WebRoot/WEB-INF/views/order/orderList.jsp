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
		<div data-options="region:'north',border:false,title:'过滤条件',collapsed:true,collapsible:true"
		style="height: 60px; background-color: #F0F0F0">
		<div>
			<form id="searchForm">
				<table>
					<tr>
						<td>订单号:</td>
						<td><input name="orderCode" id="orderCode" style="width: 110px;"
							class="easyui-textbox" data-options="prompt:'请输入订单号'" /></td>
						<td>
						<td>收货人:</td>
						<td><input name="reciever" id="reciever" style="width: 110px;"
							class="easyui-textbox" data-options="prompt:'请输入收货人'" /></td>
						<td>
						<td>联系方式:</td>
						<td><input name="recieverPhone" id="recieverPhone" style="width: 110px;"
							class="easyui-textbox" data-options="prompt:'请输入联系方式'" /></td>
						<td>
						<td>送货地址:</td>
						<td><input name="deliveryAddress" id="deliveryAddress" style="width: 110px;"
							class="easyui-textbox" data-options="prompt:'请输入送货地址'" /></td>
						<td>
						<td>结算状态:</td>
						<td>
							<select id="cleanStatus" class="easyui-combobox" name="cleanStatus"  style="width:91px;">
							    <option value="">--请选择--</option>
							    <option value="0">未结算</option>
							    <option value="1">全部结算</option>
							    <option value="2">部分结算</option>
							</select>
						</td>
						<td>支付方式:</td>
						<td>
							<select id="paymentWay" class="easyui-combobox" name="paymentWay" style="width:91px;">
							    <option value="" selected="selected">--请选择--</option>
							    <option value="1">微信支付</option>
							    <option value="2">支付宝支付</option>
							    <option value="3">现金支付</option>
							    <option value="4">打卡支付</option>
							</select>
						</td>
						<td>
						
						<c:if
								test="${fn:contains(sessionInfo.resourceList, '/order/dataGrid')}">
								<c:if
									test="${fn:contains(sessionInfo.resourceList, '/order/dataGrid/0')}">
									<a href="javascript:void(0);" class="easyui-linkbutton"
										data-options="iconCls:'icon-search',plain:true"
										onclick="searchFun();">查询</a>
								</c:if>
							</c:if> <a href="javascript:void(0);" class="easyui-linkbutton"
							data-options="iconCls:'icon-clear',plain:true"
							onclick="cleanFun();">清空</a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
    	<div data-options="region:'center',border:true">
	    	<table id="dg" 
	            url="${ctx}/order/dataGrid" 
	            singleSelect="true" fitColumns="false"
	            data-options="fit:true,border:false">
	        <thead>
	            <tr>
	                <th field="orderCode" align="center" width="120" sortable="true">订单号</th>
	                <th field="reciever" align="center" width="80">收货人</th>
	                <th field="recieverPhone" align="center" width="100">联系方式</th>
	                <th field="deliveryAddress" align="left" halign="center" width="380">送货地址</th>
	                <th field="notPayment" align="right" width="80" formatter="notPayFormatter" styler="cellStyler">未付款</th>
	                <th field="cleanStatus" align="center" width="80" formatter="cleanFormatter">结算状态</th>
	                <th field="payment" align="right" width="80" formatter="payFormatter">已付款</th>
	                <th field="paymentWay" align="center" width="80" formatter="paymentFormatter">支付方式</th>
	                <th field="totalPrice" align="right" width="80" formatter="totalFormatter">总计价格</th>
	                <th field="action" width="278" align="center" formatter="operation">操作</th>
	            </tr>
	        </thead>
	    </table>
    </div>
    <div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/order/add/0')}">
				<a onclick="addFun();" href="javascript:void(0);"
					class="easyui-linkbutton"
					data-options="plain:true,iconCls:'icon-add'">添加</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/delete')}">
			<c:if
				test="${fn:contains(sessionInfo.resourceList, '/order/delete/0')}">
				<a onclick="deleteBtn();" href="javascript:void(0);"
					class="easyui-linkbutton"
					data-options="plain:true,iconCls:'icon-del'">删除</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/edit')}">
			<c:if
				test="${fn:contains(sessionInfo.resourceList, '/order/edit/0')}">
				<a onclick="editBtn();" href="javascript:void(0);"
					class="easyui-linkbutton"
					data-options="plain:true,iconCls:'icon-edit'">修改</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/printOrder')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/order/printOrder/0')}">
			<a onclick="printBtn()" href="javascript:void(0);"
						class="easyui-linkbutton"
						data-options="plain:true,iconCls:'icon-print'">打印</a>
			</c:if>
		</c:if>
	</div>
    <div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/edit')}">
			<script type="text/javascript">
				$.canEdit = true;
			</script>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/delete')}">
			<script type="text/javascript">
				$.canDelete = true;
			</script>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/view')}">
			<script type="text/javascript">
				$.canView = true;
			</script>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/replenish')}">
			<script type="text/javascript">
				$.canReplenish = true;
			</script>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/balance')}">
			<script type="text/javascript">
				$.canBalance = true;
			</script>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/order/printOrder')}">
			<script type="text/javascript">
				$.canPrint = true;
			</script>
		</c:if>
		
	</div>
    <script type="text/javascript">
    var dataGrid;
    var soninternalTimer;
    var fatherinternalTimer;
        $(function(){
           dataGrid = $('#dg').datagrid({
	            pagination : true,
	            fitColumns: false,
	            rownumbers : true,
				pageSize : 50,
				idField : 'orderCode',
				sortName : 'orderCode',
				sortOrder : 'desc',
				pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
                view: detailview,
                detailFormatter: function (index, yeyerow) {   //用以初始化并返回一个DIV容器
                    return '<div style="padding:2px"><table class="' + yeyerow.id + 'ddv"></table></div>';
                },
                onExpandRow: function(index,yeyerow){
//                     var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
					debugger;
					$('.' + yeyerow.id + 'ddv').datagrid({
//                     ddv.datagrid({
                        url:'${ctx}/order/queryByOrderId?orderId='+yeyerow.id,
                        fitColumns:true,
                        singleSelect:true,
                        rownumbers:true,
                        loadMsg:'正在加载中...',
                        height:'auto',
                        rowStyler :function (index,row){
                        	return 'background-color:#66CDAA;color:#fff;font-weight:bold;';
                        },
                        columns:[[
                            {field:'orderDate',title:'送货日期',width:45,align:'center',formatter:function(value,row,index){
                            	return formatterDate(value);
                            	}
                            },
                            {field:'total',title:'合计',width:40,align:'center',formatter:function(value,row,index){
                            	return "￥ " + value;
                            	}
                            }
                           
                        ]],
                        onResize:function(){
                        	debugger;
                        	$.each($('#dg').datagrid('getRows'), function (i, row) {
                                $('#dg').datagrid('fixRowHeight', i);
                            });
                            $('#dg').datagrid('fixDetailRowHeight', index);
                        },
                        onLoadSuccess:function(){
//                             setTimeout(function(){
//                             	 $.each($('#dg').datagrid('getRows'), function (i, row) {
//                                      $('#dg').datagrid('fixRowHeight', i);
//                                  });
//                                  $('#dg').datagrid('fixDetailRowHeight', index);
//                             },0);
                        	clearTimeout(fatherinternalTimer);
                            fatherinternalTimer =
                            setInterval(function () {
//                                 $.each($('#dg').datagrid('getRows'), function (i, row) {
//                                     $('#dg').datagrid('fixRowHeight', i);
//                                 });
                                $('#dg').datagrid('fixDetailRowHeight', index);
                            }, 3);
                        },
                        view: detailview,
                        detailFormatter: function (index_child, babarow) {    //用以初始化并返回一个DIV容器
                            return '<div style="padding:0px"><table class="' + babarow.id + 'ddvv"></table></div>';
                        },
                        onExpandRow: function (index_child, babarow) {   //展开后触发事件
                        	debugger;
                            $('.' + babarow.id + 'ddvv').datagrid({
                            	url:'${ctx}/order/queryByDateId?dateId='+babarow.id,
                                fitColumns: true,
                                rownumbers: true,
                                loadMsg: '正在加载中...',
                                height: 'auto',
                                columns: [[
                                { field: 'goodsName', title: '名称', width: 80 },
                                { field: 'goodsQty', title: '数量', width: 80,formatter:function(value,row,index){
                                	return value + "&nbsp;" + row.goodsUnit;
                                	}
                                },
                                { field: 'goodsPrice', title: '单价', width: 80 ,formatter:function(value,row,index){
                                	return "￥ " + value + "/" + row.goodsUnit;
                            		}
                                },
                                { field: 'goodsSum', title: '金额', width: 80 ,formatter:function(value,row,index){
                                	return "￥ " + value ;
                        			}
                                }
                                ]],
                                onResize: function () {    //事件会在窗口或框架被调整大小时发生
                                    debugger;
                                	$.each($('.' + yeyerow.id + 'ddv').datagrid('getRows'), function (i, row) {
                                        $('.' + yeyerow.id + 'ddv').datagrid('fixRowHeight', i);
                                    });
                                    $.each($('#dg').datagrid('getRows'), function (i, row) {
//                                         $('#dg').datagrid('fixRowHeight', i);
                                        $('#dg').datagrid('fixDetailRowHeight', i);
                                    });
                                    //父表格改变大小
                                    $('.' + yeyerow.id + 'ddv').datagrid('fixDetailRowHeight', index_child);
                                    //爷爷表格改变大小
                                    $('#dg').datagrid('fixDetailRowHeight', index);
                                },
                                onLoadSuccess: function () {   //当数据载入成功时触发
                                	debugger;
                                	$.each($('.' + yeyerow.id + 'ddv').datagrid('getRows'), function (i, row) {
                                        $('.' + yeyerow.id + 'ddv').datagrid('fixRowHeight', i);
                                    });
                                    $.each($('#dg').datagrid('getRows'), function (i, row) {
                                        $('#dg').datagrid('fixRowHeight', i);
                                    });
                                    $('.' + yeyerow.id + 'ddv').datagrid('fixDetailRowHeight', index_child);
                                    $('#dg').datagrid('fixDetailRowHeight', index);
                                    //延迟执行一次后，点击缩进的话不能恢复原形,所以不用延迟函数，而是使用间隔函数
//                                     setTimeout(function(){
//                                     	 $.each($('.' + yeyerow.id + 'ddv').datagrid('getRows'), function (i, row) {
//                                              $('.' + yeyerow.id + 'ddv').datagrid('fixRowHeight', i);
//                                          });
//                                          $.each($('#dg').datagrid('getRows'), function (i, row) {
//                                              $('#dg').datagrid('fixRowHeight', i);
//                                              $('#dg').datagrid('fixDetailRowHeight', i);
//                                          });
//                                          $('.' + yeyerow.id + 'ddv').datagrid('fixDetailRowHeight', index_child);
//                                          $('#dg').datagrid('fixDetailRowHeight', index);
// 		                            },0);
                                    clearTimeout(soninternalTimer);
                                    soninternalTimer = setInterval(function () {
                                        $.each($('.' + yeyerow.id + 'ddv').datagrid('getRows'), function (i, row) {
                                            $('.' + yeyerow.id + 'ddv').datagrid('fixRowHeight', i);
                                        });
                                        $.each($('#dg').datagrid('getRows'), function (i, row) {
                                            $('#dg').datagrid('fixRowHeight', i);
                                            $('#dg').datagrid('fixDetailRowHeight', i);
                                        });
                                        $('.' + yeyerow.id + 'ddv').datagrid('fixDetailRowHeight', index_child);
                                        $('#dg').datagrid('fixDetailRowHeight', index);
                                    }, 0);
                                }
                            });
                        }
                    });
                    $('#dg').datagrid('fixDetailRowHeight',index);
                },
                toolbar : '#toolbar'
            });
        });
        
        function operation(val,row,index){
        	var str = '';
				if ($.canView) {
					str += '&nbsp;&nbsp;&nbsp;&nbsp;';
					str += $
							.formatString(
									'<a href="javascript:void(0)" onclick="viewFun(\'{0}\');" >查看</a>',
									row.id);
				}
				if ($.canEdit) {
					if(row.cleanStatus!=1){
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $
								.formatString(
										'<a href="javascript:void(0)" onclick="editFun(\'{0}\');" >编辑</a>',
										row.id);
					}
				}
				if ($.canDelete) {
					str += '&nbsp;&nbsp;&nbsp;&nbsp;';
					str += $
							.formatString(
									'<a href="javascript:void(0)" onclick="deleteFun(\'{0}\');" >删除</a>',
									row.id);
				}
				if($.canReplenish){
					if(row.cleanStatus!=1){
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $
								.formatString(
									'<a href="javascript:void(0)" onclick="replenishFun(\'{0}\');" >补货</a>',
									row.id);
					}
				}
				if($.canBalance){
					if(row.cleanStatus!=1){
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $
								.formatString(
										'<a href="javascript:void(0)" onclick="balanceFun(\'{0}\');" >结算</a>',
										row.id);
					}
				}
				
				if($.canPrint){
					str += '&nbsp;&nbsp;&nbsp;&nbsp;';
					str += $
							.formatString(
									'<a href="javascript:void(0)" onclick="printFun(\'{0}\');" >打印</a>',
									row.id);	
				}
				
				return str;
        }
        
        function addFun() {
			// window.location.href="${ctx}/order/addPage";
		parent.$.modalDialog({
			title : '新增订单信息',
			width : 600,
			height : 491,
			href : '${ctx}/order/addPage',
			modal : true,
			buttons : [ {
				text : '保存',
				iconCls :'icon-ok',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#orderAddForm');
					f.submit();
				}
			} , {
				text : '取消',
				iconCls :'icon-cancel',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			}]
		}); 
	}

	function deleteFun(id) {
		if (id == undefined) {//点击右键菜单才会触发这个
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {//点击操作里面的删除图标会触发这个
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.messager.confirm('询问', '您是否要删除当前订单信息？', function(b) {
			if (b) {
				progressLoad();
				$.post('${ctx}/order/delete', {
					id : id
				}, function(result) {
					if (result.success) {
						parent.$.messager.alert('提示', result.msg, 'info');
						dataGrid.datagrid('reload');
					} else {
						parent.$.messager.alert('错误', result.msg, 'error');
					}
					progressClose();
				}, 'JSON');
			}
		});
	}

	function deleteBtn() {
		var rows = dataGrid.datagrid('getSelections');
		if (rows.length <= 0) {
			$.messager.alert("提示", "请选择其中一行，再删除！", "info");
		} else {
			deleteFun(rows.id);
		}
	}

	function editBtn() {
		var rows = dataGrid.datagrid('getSelections');
		if (rows.length <= 0) {
			$.messager.alert("提示", "请选择其中一行，再编辑！", "info");
		} else {
			if(rows[0].cleanStatus == 1){
				$.messager.alert("提示", "该订单：【"+rows[0].orderCode+"】，已全部结算，请重新选择订单", "info");
			}else{
				editFun(rows.id);
			}
		}
	}
	
	function printBtn(){
		var rows = dataGrid.datagrid('getSelections');
		if (rows.length <= 0) {
			$.messager.alert("提示", "请选择其中一行，再打印！", "info");
		} else {
			printFun(rows.id);
		}
	}

	function editFun(id) {
		// 		window.location.href="${ctx}/order/editPage?id=" + id;
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$
				.modalDialog({
					title : '修改订单管理信息',
					width : 650,
					height : 494,
// 					resizable:true,
					//maximizable:true,
					href : '${ctx}/order/editPage?id=' + id,
					buttons : [ {
						text : '保存',
						iconCls :'icon-ok',
						handler : function() {
							parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
							var f = parent.$.modalDialog.handler
									.find('#orderEditForm');
							f.submit();
						}
					}, {
						text : '取消',
						iconCls :'icon-cancel',
						handler : function() {
							parent.$.modalDialog.handler.dialog('destroy');
							parent.$.modalDialog.handler = undefined;
						}
					} ]
				});
	}

	function replenishFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.modalDialog({
			title : '补货订单管理信息',
			width : 600,
			height : 391,
			href : '${ctx}/order/replenishPage?id=' + id,
			buttons : [ {
				text : '保存',
				iconCls :'icon-ok',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler
							.find('#orderReplenishForm');
					f.submit();
				}
			},
			{
				text : '取消',
 				iconCls : 'icon-cancel',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			}]
		});
	}

	function balanceFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.modalDialog({
			title : '结算订单管理信息',
			width : 600,
			height : 556,
			href : '${ctx}/order/balancePage?id=' + id,
			resizable:true,
			buttons : [ {
				text : '保存',
				iconCls :'icon-ok',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler
							.find('#orderBalanceForm');
					f.submit();
				}
			},
			{
				text : '取消',
 				iconCls : 'icon-cancel',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			}]
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
			title : '订单管理详情信息',
			width : 600,
			height : 530,
			href : '${ctx}/order/viewPage?id=' + id,
			resizable:true,
			buttons : [ 
			 {
				text : '取消',
 				iconCls : 'icon-cancel',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			}]
		});
	}
	
	function printFun(id){
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}

		parent.$.modalDialog({
			title : '打印订单管理信息',
			width : 700,
			height : 530,
			href : '${ctx}/order/printPage?id=' + id,
			resizable:true,
			buttons : [ 
			{
				text : '打印',
				iconCls : 'icon-print',
				handler : function() {
					var printArea = parent.$.modalDialog.handler.find('#printAreaView');
					
					parent.$.messager.confirm('询问', '您是否要打印当前订单信息？', function(b) {
						if (b) {
							printArea.jqprint();
						}
					});
				}
			},
			 {
				text : '取消',
 				iconCls : 'icon-cancel',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			}]
		});
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	function doPrint(){
		$("#printArea").jqprint();
	}
	
	function cleanFormatter(value,row,index){
		var str = "";
		if (value == 0) {
			str = "未结算";
		} else if (value == 1) {
			str = "全部结算";
		}else if (value == 2) {
			str = "部分结算";
		}
		return str;
	}
	function paymentFormatter(value,row,index){
		var str = "未支付";
		if (value == 1) {
			str = "微信支付";
		} else if (value == 2) {
			str = "支付宝支付";
		} else if (value == 3) {
			str = "现金支付";
		} else if (value == 4) {
			str = "打卡支付";
		}
		return str;
	}
	
	function totalFormatter(value,row,index){
		return "￥" + value;
	}
	
	function notPayFormatter(value,row,index){
	   if(row.cleanStatus == 0){
		   	return "<font style='color:#FF0000'>￥"+value+"</font>"
	   }else if(row.cleanStatus == 2){
		   return "<font style='color:#7EC0EE'>￥"+value+"</font>"
	   }
	   else{
			return  "￥" + value;
	   }
	}
	
	function payFormatter(value,row,index){
		return  "￥" + value;
	}
	
	function cellStyler(value,row,index){
// 		if(row.cleanStatus == 0){
// 		   	return "background-color:#ffee00;color:red;"
// 	   }else if(row.cleanStatus == 2){
// 		   return "background-color:#ffee00;color:#7EC0EE;"
// 	   }
// 	   else{
// 			return  "￥" + value;
// 	   }
	}
	
	
    </script>
    
    
</body>
</html>