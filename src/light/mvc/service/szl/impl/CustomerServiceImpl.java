package light.mvc.service.szl.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.Tcumstomer;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Customer;
import light.mvc.service.szl.CustomerServiceI;
import light.mvc.utils.StringUtil;
import light.mvc.utils.UploadUtils;

@Service
public class CustomerServiceImpl implements CustomerServiceI {
	@Autowired
	private BaseDaoI<Tcumstomer> customerDao;

	@Override
	public List<Customer> dataGrid(Customer customer, PageFilter ph, SessionInfo sessionInfo) {
		List<Customer> ul = new ArrayList<Customer>();
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tcumstomer t ";
		List<Tcumstomer> l = customerDao.find(hql + whereHql(customer, params, sessionInfo) + orderHql(ph), params,
				ph.getPage(), ph.getRows());
		for (Tcumstomer t : l) {
			Customer u = new Customer();
			u.setId(t.getId());
			u.setCustName(t.getCust_name());
			u.setCustAge(t.getCust_age());
			u.setCustSex(t.getCust_sex());
			u.setCustPhone(t.getCust_phone());
			u.setCustAddress(t.getCust_address());
			u.setIdCard(t.getId_card());
			u.setCustWebchat(t.getCust_webchat());
			u.setCustQq(t.getCust_qq());
			u.setUserId(t.getUser_id());
			u.setRemark(t.getRemark());
			u.setCreateDatetime(t.getCreatedatetime());
			ul.add(u);
		}
		return ul;
	}

	@Override
	public Long count(Customer customer, PageFilter ph, SessionInfo sessionInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tcumstomer t ";
		return customerDao.count("select count(*) " + hql + whereHql(customer, params, sessionInfo), params);
	}

	private String whereHql(Customer customer, Map<String, Object> params, SessionInfo sessionInfo) {
		String hql = "";
		if (customer != null) {
			if (sessionInfo.getLoginname().equals("admin")) {
				hql += " where 1=1 ";
			} else {
				hql += " where 1=1 and t.user_id = " + sessionInfo.getId();
			}
			if (StringUtil.isNotEmpty(customer.getCustName())) {
				hql += " and t.cust_name like :custName";
				params.put("custName", "%" + customer.getCustName() + "%");
			}
			if (customer.getCustSex() != null) {
				hql += " and t.cust_sex = :custSex";
				params.put("custSex", customer.getCustSex());
			}
			if (customer.getCustAge() != null) {
				hql += " and t.cust_age = :custAge";
				params.put("custAge", customer.getCustAge());
			}
			if (customer.getCustPhone() != null) {
				hql += " and t.cust_phone like :custPhone";
				params.put("custPhone", "%%" + customer.getCustPhone() + "%%");
			}
			if (customer.getCustAddress() != null) {
				hql += " and t.cust_address like :custAddress";
				params.put("custAddress", "%%" + customer.getCustAddress() + "%%");
			}
			if (customer.getCustWebchat() != null) {
				hql += " and t.cust_webchat like :custWebchat";
				params.put("custWebchat", "%%" + customer.getCustWebchat() + "%%");
			}
			if (customer.getCustQq() != null) {
				hql += " and t.cust_qq like :custQq";
				params.put("custQq", "%%" + customer.getCustQq() + "%%");
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
	public void add(SessionInfo sessionInfo, Customer customer) {
		Tcumstomer c = new Tcumstomer();
		c.setCust_name(customer.getCustName());
		c.setCust_sex(customer.getCustSex());
		c.setCust_age(customer.getCustAge());
		c.setCust_address(customer.getCustAddress());
		c.setCust_phone(customer.getCustPhone());
		c.setId_card(customer.getIdCard());
		c.setCust_webchat(customer.getCustWebchat());
		c.setCust_qq(customer.getCustQq());
		c.setRemark(customer.getRemark());
		c.setUser_id(sessionInfo.getId());
		c.setCreatedatetime(new Date());
		c.setImg_path(customer.getImgPath());
		c.setCust_email(customer.getCustEmail());
		customerDao.save(c);
	}

	@Override
	public void delete(Long id, HttpServletRequest request) {
		Tcumstomer t = customerDao.get(Tcumstomer.class, id);
		UploadUtils.deleteBeforeImg(request, t.getImg_path());
		customerDao.delete(t);
	}

	@Override
	public void edit(Customer customer) {
		Tcumstomer t = customerDao.get(Tcumstomer.class, customer.getId());
		t.setCust_name(customer.getCustName());
		t.setCust_sex(customer.getCustSex());
		t.setCust_age(customer.getCustAge());
		t.setCust_address(customer.getCustAddress());
		t.setCust_phone(customer.getCustPhone());
		t.setId_card(customer.getIdCard());
		t.setCust_webchat(customer.getCustWebchat());
		t.setCust_qq(customer.getCustQq());
		t.setRemark(customer.getRemark());
		t.setImg_path(customer.getImgPath());
		t.setCust_email(customer.getCustEmail());
		customerDao.update(t);
	}

	@Override
	public Customer get(Long id) {
		Tcumstomer t = customerDao.get(Tcumstomer.class, id);
		Customer r = new Customer();
		r.setId(t.getId());
		r.setCustName(t.getCust_name());
		r.setCustAge(t.getCust_age());
		r.setCustSex(t.getCust_sex());
		r.setCustPhone(t.getCust_phone());
		r.setCustAddress(t.getCust_address());
		r.setIdCard(t.getId_card());
		r.setCustWebchat(t.getCust_webchat());
		r.setCustQq(t.getCust_qq());
		r.setUserId(t.getUser_id());
		r.setRemark(t.getRemark());
		r.setImgPath(t.getImg_path());
		r.setCreateDatetime(t.getCreatedatetime());
		r.setCustEmail(t.getCust_email());
		return r;
	}

	@Override
	public List<Customer> exportExcelBySelect(String ids) {
		// String id[]=ids.split(",");
		// for(int i=0;i<id.length;i++){
		//
		// }
		String idss = ids.substring(0, ids.length() - 1);
		List<Tcumstomer> tcustomerList = customerDao.find("from Tcumstomer t where t.id in(" + idss + ")");
		List<Customer> customerList = new ArrayList<Customer>();
		for (Tcumstomer t : tcustomerList) {
			Customer c = new Customer();
			c.setId(t.getId());
			c.setCustName(t.getCust_name());
			c.setCustAge(t.getCust_age());
			c.setCustSex(t.getCust_sex());
			c.setCustPhone(t.getCust_phone());
			c.setCustAddress(t.getCust_address());
			c.setIdCard(t.getId_card());
			c.setCustWebchat(t.getCust_webchat());
			c.setCustQq(t.getCust_qq());
			c.setUserId(t.getUser_id());
			c.setRemark(t.getRemark());
			c.setImgPath(t.getImg_path());
			c.setCreateDatetime(t.getCreatedatetime());
			c.setCustEmail(t.getCust_email());
			customerList.add(c);
		}
		return customerList;
	}

	@Override
	public List<Customer> likeSearch(String name) {

		List<Customer> ul = new ArrayList<Customer>();
		String hql = "";
		if (StringUtil.isNotEmpty(name)) {
			hql = " from Tcumstomer t where cust_name like '%" + name + "%'";
		} else {
			hql = " from Tcumstomer t ";
		}
		List<Tcumstomer> l = customerDao.find(hql);

		for (Tcumstomer t : l) {
			Customer u = new Customer();
			u.setId(t.getId());
			u.setCustName(t.getCust_name());
			u.setCustAge(t.getCust_age());
			u.setCustSex(t.getCust_sex());
			u.setCustPhone(t.getCust_phone());
			u.setCustAddress(t.getCust_address());
			u.setIdCard(t.getId_card());
			u.setCustWebchat(t.getCust_webchat());
			u.setCustQq(t.getCust_qq());
			u.setUserId(t.getUser_id());
			u.setRemark(t.getRemark());
			u.setCreateDatetime(t.getCreatedatetime());
			ul.add(u);
		}
		return ul;

	}
}
