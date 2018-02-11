<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#orderBalanceForm').form({
			url : '${pageContext.request.contextPath}/order/balance',
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
	
	function balanceDetail(id){
		$('#dd').window({
		    title: '结算明细',
		    width: 250,
		    height: 317,
		    closed: false,
		    cache: false,
		    href : '${pageContext.request.contextPath}/order/balanceDetailPage?id=' + id,
		    modal: true,
		    onClose:function(){  
                $(this).dialog('destroy');  
            } 
		});
		
	}
	function d_close(){
		$('#dd').dialog('close');
	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto; padding: 3px;">
		<form id="orderBalanceForm" method="post" enctype="multipart/form-data">
			<input name="id" type="hidden" value="${order.id}">
			<input name="orderCode" type="hidden" value="${order.orderCode}"/>
			<table class="grid" id="list">
				<tr>
					<td class="names">订单号:</td>
					<td class="texts">
						${order.orderCode}
					</td>
					<td class="names">
						未付款:
					</td>
					<input name="notPayment" type="hidden" value="${order.notPayment}"/>
					<td class="texts" style=" color: red;">
							￥${order.notPayment}
					</td>
				</tr>
				<tr>
					<td class="names">收货人:</td>
					<td class="texts">
						${order.reciever}
					</td>
					<td class="names">
						已付款:
					</td>
					<td class="texts">
						￥${order.payment}
					</td>
				</tr>
				<tr>
					<td class="names">联系方式:</td>
					<td class="texts">
						${order.recieverPhone}
					</td>
					<td class="names">
						总计价格:
					</td>
					<td class="texts">
						<c:if test="${order.totalPrice !=null}">
							￥${order.totalPrice}
						</c:if>
					</td>
				</tr>
				<tr>
					<td class="names">送货地址:</td>
					<td colspan="5">
						${order.deliveryAddress}
					</td>
				</tr>
				<c:forEach var="orderDates" items="${order.orderDateList}"
					varStatus="state">
					<input name="orderDateIds" type="hidden" value="${orderDates.id}">
					<tr style="background-color: #F2F2F2;" >
						<td align="center" style="color: #FF00FF;">送货日期:</td>
						<td colspan="0" align="center" style="color: #FF00FF;">
							<fmt:formatDate value="${orderDates.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td align="center" style="color: #FF00FF;">
						    合计
						</td>
						<td colspan="0" style="color: #FF00FF;" align="center">
							￥${orderDates.total}
						</td>
					</tr>
					<tr style="background-color: #F2F2F2;">
						<td style="width: 71px; text-align: center;">名称</td>
						<td style="width: 71px; text-align: center;">数量</td>
						<td style="width: 71px; text-align: center;">单价</td>
						<td style="width: 71px; text-align: center;">金额</td>
<!-- 						<td style="width: 71px; text-align: center;">结算状态</td> -->
<!-- 						<td style="width: 71px; text-align: center;">操作</td> -->
					</tr>
					<c:forEach var="orderDetail" items="${order.orderDetailList}"
						varStatus="status">
						<c:if test="${orderDates.id eq orderDetail.orderDateId}">
							<tr id="appendTo${status.count}">
								<%-- 									<input name="detailIds" type="hidden"  value="${orderDetail.id}"> --%>
								<input name="orderDateId" type="hidden"
									value="${orderDetail.orderDateId}">
								<td style="width: 71px; text-align: center;">
									${orderDetail.goodsName}
								</td>
								<td style="width: 71px; text-align: center;">
									${orderDetail.goodsQty}&nbsp;${orderDetail.goodsUnit}
								</td>
<!-- 								<td style="width: 71px; text-align: center;"> -->
<%-- 									${orderDetail.goodsUnit} --%>
<!-- 								</td> -->
								<td style="width: 71px; text-align: center;">
									￥${orderDetail.goodsPrice }/${orderDetail.goodsUnit}
								</td>
								<td style="width: 71px; text-align: center;">
									￥${orderDetail.goodsSum }
								</td>
<!-- 								<td style="width: 71px; text-align: center;"> -->
<%-- 									${orderDetail.cleanStatus == 0 ?"未结算":"已结算"} --%>
<!-- 								</td> -->
<!-- 								<td style="width: 71px; text-align: center;"><a -->
<%-- 									href="javascript:;" onclick="balanceDetail(${orderDetail.id})" --%>
<!-- 									style="color: blue;">结算明细</a> -->
<!-- 								</td> -->
							</tr>
						</c:if>
					</c:forEach>
				</c:forEach>
			</table>
			<table class="grid">
				<tr style="background-color: #F2F2F2;">
					<td style="width: 71px; text-align: center;">支付金额</td>
					<td style="width: 71px; text-align: center;">支付方式</td>
					<td style="width: 71px; text-align: center;">支付时间</td>
					<td style="width: 71px; text-align: center;">结算时间</td>
				</tr>
				<tr>
					<td style="width: 71px; text-align: center;">
						<input id="payment" name="payment" class="easyui-textbox" style="width: 91px;" required data-options="validType:'number'"/>
					</td>
					<td style="width: 71px; text-align: center;">
						<select id="paymentWay" class="easyui-combobox" name="paymentWay" data-options="required:true,editable:false" style="width:91px;">
						    <option value=""></option>
						    <option value="1">微信支付</option>
						    <option value="2">支付宝支付</option>
						    <option value="3">现金支付</option>
						    <option value="4">打卡支付</option>
						</select>
					</td>
					<td style="width: 71px; text-align: center;">
						<input class="easyui-datetimebox" name="paymentDate" required style="width: 142px;"/>
					</td>
					<td style="width: 71px; text-align: center;">
						<input class="easyui-datetimebox" name="cleanDate" required style="width: 142px;"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<div id="dd">
</div>
