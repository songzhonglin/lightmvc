<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#orderEditForm').form({
			url : '${pageContext.request.contextPath}/order/edit',
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
	
	function addRow(val,count){
		var len=$("#list tr").length+1;
		var str="<tr id='appendTo"+len+"'>";
// 		str+="<input type=\"hidden\" name='detailIds' />";
		str+="<input type=\"hidden\" name='orderDateId' value='"+val+"'/>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsNameIds"+len+"' name='goodsNameIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsQtys"+len+"'  name='goodsQtys' onkeyup='cal("+len+")' class='easyui-validatebox'  style='width: 90px;' required data-options=\"validType:'positiveInteger'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsUnitIds"+len+"' name='goodsUnitIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsPrices"+len+"' name='goodsPrices' onkeyup='cal("+len+")' class='easyui-validatebox'  style='width: 90px;' required data-options=\"validType:'number'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsSums"+len+"' name='goodsSums'  class='easyui-textbox'  readonly='readonly' style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><a href=\"javascript:;\" onclick=\"addRow("+val+","+len+")\" style=\"color: blue;\">添加</a>&nbsp;<a href='javascript:;' onclick='deleteRow(this)' style='color: blue;'>删除</a></td>";
		str+="</tr>";
// 		if(len >21){
// 			parent.$.messager.alert('提示', "订单明细已上限，请勿再添加！", 'info');
// 			return;
// 		}
		$("#appendTo"+count).after(str);
		$.parser.parse("#appendTo"+len);
	}
	function deleteRow(obj){
		 $(obj).parent().parent().remove(); 
	}
	
	function cal(obj){
		var val1=$("#goodsQtys"+obj).val();
		var val2=$("#goodsPrices"+obj).val();
		if(val1!="" && val2!=""){
			var result=(Number(val1*val2)).toFixed(2);
			// var value=result.replace("(?<=\\d)(?=(?:\\d{3})+$)", ",");
			var value=result.replace(/(\d{1,2})(?=(\d{3})+\.)/g, '$1,');
			$("#goodsSums"+obj).textbox("setValue", result);
		}
	}
</script>
<script type="text/javascript">
$(function () {
	$('#reciever').combobox({  
	    prompt:'输入关键字检索',  
	    required:true,  
	    url:'${ctx}/customer/likeSearch',  
	    editable:true,  
	    hasDownArrow:false,  
	    filter: function(q, row){
	        var opts = $(this).combobox('options');
	        debugger;
	        return row[opts.textField].indexOf(q) == 0;  
	    }  
	}); 
});

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto; padding: 3px;">
		<form id="orderEditForm" method="post" enctype="multipart/form-data">
			<input name="id" type="hidden" value="${order.id}">
			<table class="grid" id="list">
				<tr>
					<td class="names">收货人:</td>
					<td colspan="5">
						<input class="easyui-combobox" name="reciever" id="reciever" value="${order.reciever}" data-options="valueField:'id',textField:'custName',panelHeight:'auto',panelMaxHeight:200,panelMinHeight:100"  style="width: 120px;"/>
					</td>
				</tr>
				<tr>
					<td class="names">联系方式:</td>
					<td colspan="5"><input name="recieverPhone"
						class="easyui-numberbox"
						data-options="width:'120',required:true,prompt:'请正确输入联系方式',validType:'telNum'"
						value="${order.recieverPhone}">
					</td>
				</tr>
				<tr>
					<td class="names">送货地址:</td>
					<td colspan="5"><input name="deliveryAddress"
						class="easyui-textbox"
						data-options="width:'100%',required:true,prompt:'请正确输入送货地址'" value="${order.deliveryAddress}"></td>
				</tr>
				<c:forEach var="orderDates" items="${order.orderDateList}"
					varStatus="state">
					<input name="orderDateIds" type="hidden" value="${orderDates.id}">
					<tr>
						<td class="names">送货日期:</td>
						<td colspan="6">
							<%-- 							<fmt:formatDate value="${orderDates.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/> --%>
							<input class="easyui-datetimebox" name="orderDates" required
							value="${orderDates.orderDate}" />
						</td>
					</tr>
					<tr style="background-color: #F2F2F2;">
						<td style="width: 71px; text-align: center;">名称</td>
						<td style="width: 71px; text-align: center;">数量</td>
						<td style="width: 71px; text-align: center;">单位</td>
						<td style="width: 71px; text-align: center;">单价</td>
						<td style="width: 71px; text-align: center;">金额</td>
						<td style="width: 71px; text-align: center;">操作</td>
					</tr>
					<c:forEach var="orderDetail" items="${order.orderDetailList}"
						varStatus="status">
						<c:if test="${orderDates.id eq orderDetail.orderDateId}">
							<tr id="appendTo${status.count}">
								<%-- 									<input name="detailIds" type="hidden"  value="${orderDetail.id}"> --%>
								<input name="orderDateId" type="hidden"
									value="${orderDetail.orderDateId}">
								<td style="width: 71px; text-align: center;"><select
									id="goodsNameIds${status.count}" name="goodsNameIds"
									style="width: 90px;" class="easyui-combobox"
									data-options="editable:false,valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,onLoadSuccess : function() { $('#goodsNameIds'+${status.count}).combobox('setValue', ${orderDetail.goodsNameId}); }">
								</select> <%-- 									 	${orderDetail.goodsName} --%></td>
								<td style="width: 71px; text-align: center;"><input
									id="goodsQtys${status.count}" name="goodsQtys" onkeyup="cal(${status.count})"
									class="easyui-validatebox" style="width: 90px;" required
									value="${orderDetail.goodsQty}" data-options="validType:'positiveInteger'"/></td>
								<td style="width: 71px; text-align: center;"><select
									id="goodsUnitIds${status.count}" name="goodsUnitIds"
									style="width: 90px;" class="easyui-combobox"
									data-options="editable:false,valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,onLoadSuccess : function() { $('#goodsUnitIds'+${status.count}).combobox('setValue', ${orderDetail.goodsUnitId}); }"></select>
									<%--  										${orderDetail.goodsUnit} --%></td>
								<td style="width: 71px; text-align: center;"><input
									id="goodsPrices${status.count}" name="goodsPrices" onkeyup="cal(${status.count})"
									class="easyui-validatebox" style="width: 90px;" required
									value="${orderDetail.goodsPrice }" data-options="validType:'number'"/></td>
								<td style="width: 71px; text-align: center;"><input
									id="goodsSums${status.count}" name="goodsSums"
									class="easyui-textbox" readonly="readonly" style="width: 90px;"
									required value="${orderDetail.goodsSum }" /></td>
								<td style="width: 71px; text-align: center;">
								<a href="javascript:;"
									onclick="addRow(${orderDetail.orderDateId},${status.count})"
									style="color: blue;">添加</a>&nbsp;
									<c:if test="${status.index !=0}">
										<a href="javascript:;" onclick="deleteRow(this)" style="color: blue;">删除</a>
								   </c:if>
								</td>
									
								
							</tr>
						</c:if>
					</c:forEach>
				</c:forEach>
			</table>
		</form>
	</div>
</div>
