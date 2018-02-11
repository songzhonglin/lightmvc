package light.mvc.service.szl.impl;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.TorderBalanceHis;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Order;
import light.mvc.pageModel.szl.OrderBalanceHis;
import light.mvc.service.szl.OrderBalanceHisServiceI;

@Service
public class OrderBalanceHisImpl implements OrderBalanceHisServiceI {
	@Autowired
	private BaseDaoI<TorderBalanceHis> orderBalanceHisDao;

	@Override
	public List<Order> dataGrid(OrderBalanceHis orderBalanceHis, PageFilter ph, SessionInfo sessionInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long count(OrderBalanceHis orderBalanceHis, PageFilter ph, SessionInfo sessionInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void add(SessionInfo sessionInfo, OrderBalanceHis orderBalanceHis) {

	}

	@Override
	public void delete(Long id, HttpServletRequest request) {

	}

	@Override
	public OrderBalanceHis get(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<OrderBalanceHis> obhList(Long orderId) {
		List<TorderBalanceHis> list = orderBalanceHisDao
				.find("from TorderBalanceHis t where t.orderId=" + orderId + "order by t.createTime asc");
		List<OrderBalanceHis>  resultList= new ArrayList<OrderBalanceHis>();
		for (TorderBalanceHis torderBalanceHis : list) {
			OrderBalanceHis obh=new OrderBalanceHis();
			BeanUtils.copyProperties(torderBalanceHis, obh);
			resultList.add(obh);
		}
		return resultList;
	}

}
