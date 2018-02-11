package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.Category;

public interface CategoryServiceI {
	public List<Category> dataGrid(Category category, PageFilter ph, SessionInfo sessionInfo);

	public Long count(Category category, PageFilter ph,SessionInfo sessionInfo);

	public void add(SessionInfo sessionInfo, Category category);

	public void delete(Long id, HttpServletRequest request);

	public void edit(Category category);

	public Category get(Long id);
	

	public List<Tree> tree();
}
