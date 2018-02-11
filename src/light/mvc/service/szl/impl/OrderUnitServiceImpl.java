package light.mvc.service.szl.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.TorderUnit;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.OrderUnit;
import light.mvc.service.szl.OrderUnitServiceI;

@Service
public class OrderUnitServiceImpl implements OrderUnitServiceI {
	@Autowired
	private BaseDaoI<TorderUnit> orderUnitDao;

	@Override
	public List<OrderUnit> dataGrid(OrderUnit orderUnit, PageFilter ph, SessionInfo sessionInfo) {
		List<OrderUnit> list = new ArrayList<OrderUnit>();
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from TorderUnit t ";
		List<TorderUnit> l = orderUnitDao.find(hql + whereHql(orderUnit, params, sessionInfo) + orderHql(ph), params,
				ph.getPage(), ph.getRows());
		for (TorderUnit t : l) {
			OrderUnit c = new OrderUnit();
			BeanUtils.copyProperties(t, c);
			list.add(c);
		}
		return list;
	}

	@Override
	public Long count(OrderUnit orderUnit, PageFilter ph, SessionInfo sessionInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from TorderUnit t ";
		return orderUnitDao.count("select count(*) " + hql + whereHql(orderUnit, params, sessionInfo), params);
	}

	@Override
	public void add(SessionInfo sessionInfo, OrderUnit orderUnit) {
		TorderUnit c = new TorderUnit();
		BeanUtils.copyProperties(orderUnit, c);
		c.setCreater(sessionInfo.getName());
		c.setCreateTime(new Date());
		orderUnitDao.save(c);
	}

	@Override
	public void delete(Long id, HttpServletRequest request) {
		TorderUnit t = orderUnitDao.get(TorderUnit.class, id);
		orderUnitDao.delete(t);
	}

	@Override
	public void edit(OrderUnit orderUnit) {
		TorderUnit t = orderUnitDao.get(TorderUnit.class, orderUnit.getId());
		t.setUnitName(orderUnit.getUnitName());
		t.setRemark(orderUnit.getRemark());
		orderUnitDao.update(t);

	}

	@Override
	public OrderUnit get(Long id) {
		TorderUnit t = orderUnitDao.get(TorderUnit.class, id);
		OrderUnit r = new OrderUnit();
		BeanUtils.copyProperties(t, r);
		return r;
	}

	private String whereHql(OrderUnit orderUnit, Map<String, Object> params, SessionInfo sessionInfo) {
		String hql = "";
		if (orderUnit != null) {
			hql += " where 1=1 ";
			if (orderUnit.getUnitName() != null) {
				hql += " and t.unitName = :unitName";
				params.put("unitName", "%%" + orderUnit.getUnitName() + "%%");
			}
		}
		return hql;
	}

	private String orderHql(PageFilter ph) {
		String orderString = "";
		if ((ph.getSort() != null) && (ph.getOrder() != null)) {
			orderString = " order by t." + ph.getSort() + " " + ph.getOrder();
		}
		return orderString;
	}

	@Override
	public List<Tree> tree() {
		List<TorderUnit> l = null;
		List<Tree> lt = new ArrayList<Tree>();
		l = orderUnitDao.find("select distinct t from TorderUnit t order by t.id");
		if ((l != null) && (l.size() > 0)) {
			for (TorderUnit r : l) {
				Tree tree = new Tree();
				tree.setId(r.getId().toString());
				tree.setText(r.getUnitName());
				lt.add(tree);
			}
		}
		return lt;
	}

}
