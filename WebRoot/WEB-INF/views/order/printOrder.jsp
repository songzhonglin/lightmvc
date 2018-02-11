<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" id="printAreaView"
		style="overflow: auto; padding: 3px;">
		<form id="orderEditForm" method="post" enctype="multipart/form-data">
			<input name="id" type="hidden" value="${order.id}">
			<table class="grid">
			    <tr>
			     <td colspan="4" align="center" style="font-size: 16;font-weight: bold;">送货单详情信息</td>
			    </tr>
				<tr>
					<td class="names">订单号:</td>
					<td class="texts">
						${order.orderCode}
					</td>
					<td class="names">
						未付款:
					</td>
					<td class="texts" style="color: red;">
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
					<td class="names">结算状态:</td>
					<td class="texts">
						<c:if test="${order.cleanStatus eq 0}">
							未结算
						</c:if>
						<c:if test="${order.cleanStatus eq 1}">
							全部结算
						</c:if>
						<c:if test="${order.cleanStatus eq 2}">
							部分结算
						</c:if>
					</td>
					<td class="names">结算时间:</td>
					<td class="texts">
						<fmt:formatDate value="${order.cleanDate}" pattern="yyyy-MM-dd HH:mm:ss"/> 
					</td>
					
				</tr>
				<tr>
					<td class="names">支付方式:</td>
					<td class="texts">
						<c:if test="${order.paymentWay eq 0 }">
							
						</c:if>
						<c:if test="${order.paymentWay eq 1 }">
							微信支付
						</c:if>
						<c:if test="${order.paymentWay eq 2 }">
							支付宝支付
						</c:if>
						<c:if test="${order.paymentWay eq 3 }">
							现金支付
						</c:if>
						<c:if test="${order.paymentWay eq 4 }">
							打卡支付
						</c:if>
					</td>
					<td class="names">支付时间:</td>
					<td class="texts">
						<fmt:formatDate value="${order.paymentDate}" pattern="yyyy-MM-dd HH:mm:ss"/> 
					</td>
					
				</tr>
				<tr>
				<tr>
					<td class="names">
						备注:
					</td>
					<td colspan="4"  style="width: 100px;">
					  
					</td>
				</tr>
				    <td class="names">送货地址:</td>
					<td colspan="4" style="width: 100px;">
						${order.deliveryAddress}
					</td>
				</tr>
				<c:forEach var="orderDates" items="${order.orderDateList}"
					varStatus="state">
					<input name="orderDateIds" type="hidden" value="${orderDates.id}">
					<tr style="background-color: #F2F2F2;" >
						<td align="center" style="color: #FF00FF;width: 100px;">送货日期:</td>
						<td colspan="0" style="color: #FF00FF;width: 100px;" align="center">
							<fmt:formatDate value="${orderDates.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td align="center" style="color: #FF00FF;width: 100px;">
						    合计
						</td>
						<td colspan="0" style="color: #FF00FF;width: 100px;" align="center">
							￥${orderDates.total}
						</td>
					</tr>
					<tr style="background-color: #F2F2F2;">
						<td style="width: 100px; text-align: center;">名称</td>
						<td style="width: 100px; text-align: center;">数量</td>
						<td style="width: 100px; text-align: center;">单价</td>
						<td style="width: 100px; text-align: center;">金额</td>
					</tr>
					<c:forEach var="orderDetail" items="${order.orderDetailList}"
						varStatus="status">
						<c:if test="${orderDates.id eq orderDetail.orderDateId}">
							<tr id="appendTo${status.count}">
								<input name="orderDateId" type="hidden"
									value="${orderDetail.orderDateId}">
								<td style="width: 100px; text-align: center;">
									${orderDetail.goodsName}
								</td>
								<td style="width: 100px; text-align: center;">
									${orderDetail.goodsQty}&nbsp;${orderDetail.goodsUnit}
								</td>
								<td style="width: 100px; text-align: center;">
									￥${orderDetail.goodsPrice }/${orderDetail.goodsUnit}
								</td>
								<td style="width: 100px; text-align: center;">
									￥${orderDetail.goodsSum }
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</c:forEach>
			</table>
		</form>
	</div>
</div>
<div id="dd">
</div>
<div id="record">
</div>
