package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Order;
import light.mvc.pageModel.szl.OrderDate;
import light.mvc.pageModel.szl.OrderDetail;

public interface OrderServiceI {
	public List<Order> dataGrid(Order order, PageFilter ph, SessionInfo sessionInfo);

	public Long count(Order order, PageFilter ph,SessionInfo sessionInfo);
	
	public void add(SessionInfo sessionInfo, Order order);

	public void delete(Long id, HttpServletRequest request);
	
	public void edit(Order order,SessionInfo sessionInfo);

	public Order get(Long id);

	public void replenish(SessionInfo sessionInfo, Order order);
	// 结算订单
	public void balance(Order order,SessionInfo sessionInfo);
	
	// 结算订单
	public boolean isOverPay(Order order,SessionInfo sessionInfo);
	
	List<OrderDate> queryByOrderId(Integer orderId);
	
	List<OrderDetail> queryByDateId(Integer dateId);
}
