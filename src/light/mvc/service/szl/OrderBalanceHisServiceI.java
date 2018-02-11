package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Order;
import light.mvc.pageModel.szl.OrderBalanceHis;

public interface OrderBalanceHisServiceI {
	public List<Order> dataGrid(OrderBalanceHis orderBalanceHis, PageFilter ph, SessionInfo sessionInfo);

	public Long count(OrderBalanceHis orderBalanceHis, PageFilter ph,SessionInfo sessionInfo);
	
	public void add(SessionInfo sessionInfo, OrderBalanceHis orderBalanceHis);

	public void delete(Long id, HttpServletRequest request);

	public OrderBalanceHis get(Long id);
	
	public List<OrderBalanceHis> obhList(Long orderId);
}
