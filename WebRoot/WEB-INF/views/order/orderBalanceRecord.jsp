<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto; padding: 3px;">
		<form id="orderEditForm" method="post" enctype="multipart/form-data">
			<table class="grid" id="list">
							<tr style="background-color: #F2F2F2;">
								<td style="width: 71px; text-align: center;">次数</td>
								<td style="width: 71px; text-align: center;">支付金额</td>
								<td style="width: 71px; text-align: center;">支付方式</td>
								<td style="width: 71px; text-align: center;">支付日期</td>
								<td style="width: 71px; text-align: center;">结算状态</td>
								<td style="width: 71px; text-align: center;">结算日期</td>
<!-- 								<td style="width: 71px; text-align: center;">创建人</td> -->
<!-- 								<td style="width: 71px; text-align: center;">创建时间</td> -->
							</tr>
						<c:forEach var="balance" items="${orderBalance}" varStatus="state">
							<c:if test="${state.index % 2 == 0}">
								<tr>
							</c:if>
							<c:if test="${state.index % 2 == 1}">
								<tr style="background-color: #FAFAFA">
							</c:if>
									<td style="width: 71px; text-align: center;">${state.count}</td>
									<td style="width: 71px; text-align: center;">
									￥${balance.paymentPrice}
									</td>
									<td style="width: 71px; text-align: center;">
									<c:if test="${balance.paymentWay eq 0 }">
										未支付
									</c:if>
									<c:if test="${balance.paymentWay eq 1 }">
										微信支付
									</c:if>
									<c:if test="${balance.paymentWay eq 2 }">
										支付宝支付
									</c:if>
									<c:if test="${balance.paymentWay eq 3 }">
										现金支付
									</c:if>
									<c:if test="${balance.paymentWay eq 4 }">
										打卡支付
									</c:if>
									</td>
									<td style="width: 120px; text-align: center;">
										<fmt:formatDate value="${balance.paymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td style="width: 71px; text-align: center;">
										<c:if test="${balance.cleanStatus eq 0 }">
											未结算
										</c:if>
										<c:if test="${balance.cleanStatus eq 1 }">
											全部结算
										</c:if>
										<c:if test="${balance.cleanStatus eq 2 }">
											部分结算
										</c:if>
									</td>
									<td style="width: 120px; text-align: center;">
										<fmt:formatDate value="${balance.cleanTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
<!-- 									<td style="width: 71px;" align="center"> -->
<%-- 										${balance.creater} --%>
<!-- 									</td> -->
<!-- 									<td style="width: 120px;" align="center"> -->
<%-- 										<fmt:formatDate value="${balance.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>  --%>
<!-- 									</td> -->
								</tr>
						</c:forEach>
						<c:if test="${orderBalance== null || fn:length(orderBalance) == 0}">
							<tr>
								<td align="center" colspan="8">暂无结算记录！</td>
							</tr>
						</c:if>
			</table>
		</form>
	</div>
</div>
