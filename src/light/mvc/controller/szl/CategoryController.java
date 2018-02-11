package light.mvc.controller.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.Category;
import light.mvc.service.szl.CategoryServiceI;

@Controller
@RequestMapping("/category")
public class CategoryController extends BaseController {
	@Autowired
	private CategoryServiceI categoryService;

	@RequestMapping("/manager")
	public String manager() {
		return "/category/categoryList";
	}

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(Category category, PageFilter ph, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Grid grid = new Grid();
		grid.setRows(categoryService.dataGrid(category, ph, sessionInfo));
		grid.setTotal(categoryService.count(category, ph, sessionInfo));
		return grid;
	}

	@RequestMapping("/viewPage")
	public String viewPage(HttpServletRequest request, Long id) {
		Category r = categoryService.get(id);
		request.setAttribute("category", r);
		return "/category/categoryView";
	}

	@RequestMapping("/addPage")
	public String addPage() {
		return "/category/categoryAdd";
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(Category category, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			categoryService.add(sessionInfo, category);
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
			categoryService.delete(id, request);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/get")
	@ResponseBody
	public Category get(Long id) {
		return categoryService.get(id);
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		Category r = categoryService.get(id);
		request.setAttribute("category", r);
		return "/category/categoryEdit";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(Category category, HttpServletRequest request) {
		Json j = new Json();
		try {
			categoryService.edit(category);
				j.setSuccess(true);
				j.setMsg("编辑成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}
	
	@RequestMapping("/tree")
	@ResponseBody
	public List<Tree> tree() {
		return categoryService.tree();
	}

//	@RequestMapping("/export")
//	@ResponseBody
//	public String exportExcel(Customer customer, PageFilter ph, HttpServletRequest request,
//			HttpServletResponse response) throws IOException {
//		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
//		List<Customer> customerList = customerService.dataGrid(customer, ph, sessionInfo);
//		String fileName = "客户信息导出";
//		LinkedList<Map<String, String>> list = createExcelRecord(customerList);
//		ByteArrayOutputStream os = new ByteArrayOutputStream();
//		ExcelExportUtil.generateExcel(list, fileName).write(os);
//		ExcelExportUtil.createStream(response, fileName, os);
//		return null;
//	}

	// // 导出设置值
	// private LinkedList<Map<String, String>> createExcelRecord(List<Customer>
	// customerList) {
	// LinkedList<Map<String, String>> listmap = new LinkedList<Map<String,
	// String>>();
	// Customer customer = null;
	// for (int j = 0; j < customerList.size(); j++) {
	// customer = customerList.get(j);
	// LinkedHashMap<String, String> mapValue = new LinkedHashMap<String,
	// String>();
	// mapValue.put("序号", customer.getId().toString());
	// mapValue.put("客户名称", customer.getCustName());
	// mapValue.put("性别", customer.getCustSex() == 0 ? "男" : "女");
	// mapValue.put("年龄", customer.getCustAge().toString());
	// mapValue.put("电话", customer.getCustPhone());
	// mapValue.put("身份证", customer.getIdCard());
	// mapValue.put("微信号", customer.getCustWebchat());
	// mapValue.put("QQ号 ", customer.getCustQq());
	// mapValue.put("地址 ", customer.getCustAddress());
	// mapValue.put("备注", customer.getRemark());
	// mapValue.put("创建时间 ", customer.getCreateDatetime().toString());
	// listmap.add(mapValue);
	// }
	// return listmap;
	// }
}
