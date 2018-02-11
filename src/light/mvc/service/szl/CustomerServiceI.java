package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Customer;

public interface CustomerServiceI {
	public List<Customer> dataGrid(Customer customer, PageFilter ph, SessionInfo sessionInfo);

	public Long count(Customer customer, PageFilter ph,SessionInfo sessionInfo);

	public void add(SessionInfo sessionInfo, Customer customer);

	public void delete(Long id, HttpServletRequest request);

	public void edit(Customer customer);

	public Customer get(Long id);
	
	public List<Customer> exportExcelBySelect(String ids);

	public List<Customer> likeSearch(String name);
}
