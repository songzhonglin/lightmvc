package light.mvc.controller.szl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import light.mvc.controller.base.BaseController;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.pageModel.base.Grid;
import light.mvc.pageModel.base.Json;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Customer;
import light.mvc.service.szl.CustomerServiceI;
import light.mvc.utils.ExcelExportUtil;
import light.mvc.utils.StringUtil;
import light.mvc.utils.UploadUtils;

@Controller
@RequestMapping("/customer")
public class CustomerController extends BaseController {
	@Autowired
	private CustomerServiceI customerService;

	@RequestMapping("/manager")
	public String manager() {
		return "/customer/customerList";
	}

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(Customer customer, PageFilter ph, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Grid grid = new Grid();
		grid.setRows(customerService.dataGrid(customer, ph, sessionInfo));
		grid.setTotal(customerService.count(customer, ph, sessionInfo));
		return grid;
	}

	@RequestMapping("/viewPage")
	public String viewPage(HttpServletRequest request, Long id) {
		Customer r = customerService.get(id);
		request.setAttribute("customer", r);
		return "/customer/customerView";
	}

	@RequestMapping("/addPage")
	public String addPage() {
		return "/customer/customerAdd";
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(Customer customer, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			boolean flag = UploadUtils.chkImg(customer.getSourceFile(), request);
			if (!flag) {
				j.setMsg("上传图片的格式为：jpg , jpeg , png , gif ！");
				return j;
			} else {
				if (!customer.getSourceFile().isEmpty()) {
					UploadUtils.createMultipartHttpServletRequest2(request);
					String imgPath = UploadUtils.uploadImg(customer.getSourceFile(), request);
					customer.setImgPath(imgPath);
				}
				customerService.add(sessionInfo, customer);
				j.setSuccess(true);
				j.setMsg("添加成功！");
			}
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
			customerService.delete(id, request);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/get")
	@ResponseBody
	public Customer get(Long id) {
		return customerService.get(id);
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		Customer r = customerService.get(id);
		request.setAttribute("customer", r);
		return "/customer/customerEdit";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(Customer customer, HttpServletRequest request) {
		Json j = new Json();
		try {
			UploadUtils.deleteBeforeImg(request, customer.getImgPath());
			boolean flag = UploadUtils.chkImg(customer.getSourceFile(), request);
			if (!flag) {
				j.setMsg("上传图片的格式为：jpg , jpeg , png , gif ！");
				return j;
			} else {
				if (!customer.getSourceFile().isEmpty()) {
					UploadUtils.createMultipartHttpServletRequest2(request);
					String imgPath = UploadUtils.uploadImg(customer.getSourceFile(), request);
					customer.setImgPath(imgPath);
				}
				customerService.edit(customer);
				j.setSuccess(true);
				j.setMsg("编辑成功！");
			}
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/export")
	@ResponseBody
	public String exportExcel(Customer customer, PageFilter ph, HttpServletRequest request,
			HttpServletResponse response, String ids) throws IOException {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		List<Customer> customerList = null;
		if (StringUtil.isNotEmpty(ids)) {// 不为空是true
			// String id[] = ids.split(",");
			customerList = customerService.exportExcelBySelect(ids);
		} else {
			customerList = customerService.dataGrid(customer, ph, sessionInfo);
		}

		String fileName = UUID.randomUUID() + "";
		String titleName = "客户管理信息";
		LinkedList<Map<String, String>> list = createExcelRecord(customerList);
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		ExcelExportUtil.generateExcel(list, titleName).write(os);
		ExcelExportUtil.createStream(response, fileName, os);
		return null;
	}

	// 导出设置值
	private LinkedList<Map<String, String>> createExcelRecord(List<Customer> customerList) {
		LinkedList<Map<String, String>> listmap = new LinkedList<Map<String, String>>();
		Customer customer = null;
		if (customerList != null && customerList.size() > 0) {
			for (int j = 0; j < customerList.size(); j++) {
				customer = customerList.get(j);
				LinkedHashMap<String, String> mapValue = new LinkedHashMap<String, String>();
				mapValue.put("序号", customer.getId().toString());
				mapValue.put("客户名称", customer.getCustName());
				mapValue.put("性别", customer.getCustSex() == 0 ? "男" : "女");
				mapValue.put("年龄", customer.getCustAge().toString());
				mapValue.put("电话", customer.getCustPhone());
				mapValue.put("身份证", customer.getIdCard());
				mapValue.put("微信号", customer.getCustWebchat());
				mapValue.put("QQ号 ", customer.getCustQq());
				mapValue.put("地址 ", customer.getCustAddress());
				mapValue.put("备注", customer.getRemark());
				mapValue.put("创建时间 ", customer.getCreateDatetime().toString());
				listmap.add(mapValue);
			}
		}
		return listmap;
	}

	/**
	 * 订单收货人获取
	 * 
	 * @param customer
	 * @param request
	 * @return
	 */
	// @RequestMapping("/likeSearch")
	// @ResponseBody
	// public String likeSearch(HttpServletRequest request, String name) {
	// List<Customer> custList = customerService.likeSearch(name);
	// List<HashMap<String, Object>> jsonArr = new ArrayList<HashMap<String,
	// Object>>();
	// for (Customer c : custList) {
	// HashMap<String, Object> hm = new HashMap<String, Object>();
	// hm.put("id", c.getId());
	// hm.put("text", c.getCustName());
	// jsonArr.add(hm);
	// }
	// HashMap<String, Object> hm = new HashMap<String, Object>();
	// hm.put("rows", jsonArr);
	// JSONObject result = JSONObject.fromObject(hm);
	//
	// return hm.toString();
	//
	// }

	/**
	 * 订单收货人获取
	 * 
	 * @param customer
	 * @param request
	 * @return
	 */
	@RequestMapping("/likeSearch")
	@ResponseBody
	public List<Customer> likeSearch(HttpServletRequest request, String name) {
		List<Customer> custList = customerService.likeSearch(name);
		return custList;

	}

}
