package light.mvc.controller.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import light.mvc.controller.base.BaseController;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.model.szl.TorderDetail;
import light.mvc.pageModel.base.Grid;
import light.mvc.pageModel.base.Json;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Kind;
import light.mvc.pageModel.szl.Order;
import light.mvc.pageModel.szl.OrderDate;
import light.mvc.pageModel.szl.OrderDetail;
import light.mvc.service.szl.OrderDetailServiceI;
import light.mvc.service.szl.OrderServiceI;

@Controller
@RequestMapping("/order")
public class OrderController extends BaseController {
	@Autowired
	private OrderServiceI orderService;
	@Autowired
	private OrderDetailServiceI orderDetailService;

	@RequestMapping("/manager")
	public String manager() {
		return "/order/orderList";
	}

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(Order order, PageFilter ph, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Grid grid = new Grid();
		grid.setRows(orderService.dataGrid(order, ph, sessionInfo));
		grid.setTotal(orderService.count(order, ph, sessionInfo));
		return grid;
	}

	@RequestMapping("/addPage")
	public String addPage() {
		return "/order/orderAdd";
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(Order order, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			orderService.add(sessionInfo, order);
			j.setSuccess(true);
			j.setMsg("添加成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/delete")
	@ResponseBody
	public Json delete(Long id, HttpServletRequest request) {
		Json j = new Json();
		try {
			orderService.delete(id, request);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		Order r = orderService.get(id);
		request.setAttribute("order", r);
		return "/order/orderEdit";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(Order order, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			orderService.edit(order, sessionInfo);
			j.setSuccess(true);
			j.setMsg("编辑成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	// 补货
	@RequestMapping("/replenishPage")
	public String replenishPage(HttpServletRequest request, Long id) {
		Order r = orderService.get(id);
		request.setAttribute("order", r);
		return "/order/orderReplenish";
	}

	@RequestMapping("/replenish")
	@ResponseBody
	public Json replenish(Order order, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			orderService.replenish(sessionInfo, order);
			j.setSuccess(true);
			j.setMsg("添加成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/viewPage")
	public String viewPage(HttpServletRequest request, Long id) {
		Order r = orderService.get(id);
		request.setAttribute("order", r);
		return "/order/orderView";
	}
	
	@RequestMapping("/queryByOrderId")
	@ResponseBody
	public List<OrderDate> queryByOrderId(HttpServletRequest request, Integer orderId) {
		return orderService.queryByOrderId(orderId);
	}
	
	@RequestMapping("/queryByDateId")
	@ResponseBody
	public List<OrderDetail> queryByDateId(HttpServletRequest request, Integer dateId) {
		return orderService.queryByDateId(dateId);
	}
	
	@RequestMapping("/printPage")
	public String printPage(HttpServletRequest request, Long id) {
		Order r = orderService.get(id);
		request.setAttribute("order", r);
		return "/order/printOrder";
	}

	@RequestMapping("/viewDetailPage")
	public String viewDetailPage(HttpServletRequest request, Long id) {
		OrderDetail r = orderDetailService.get(id);
		request.setAttribute("orderDetail", r);
		return "/order/orderDetailView";
	}
	
	@RequestMapping("/balancePage")
	public String balancePage(HttpServletRequest request, Long id) {
		Order r = orderService.get(id);
		request.setAttribute("order", r);
		return "/order/orderBalance";
	}
	
	@RequestMapping("/balanceDetailPage")
	public String balanceDetailPage(HttpServletRequest request, Long id) {
		OrderDetail r = orderDetailService.get(id);
		request.setAttribute("orderDetail", r);
		return "/order/orderBalanceDetail";
	}
	
	@RequestMapping("/balance")
	@ResponseBody
	public Json balance(Order order, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			boolean resultFlag=orderService.isOverPay(order, sessionInfo);
			if(resultFlag){
				j.setMsg("该订单：【"+order.getOrderCode()+"】还有【￥"+order.getNotPayment()+"】未付款，请正确输入金额！");
			}else{
				orderService.balance(order, sessionInfo);
				j.setSuccess(true);
				j.setMsg("结算订单成功！");
			}
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}
	
}
