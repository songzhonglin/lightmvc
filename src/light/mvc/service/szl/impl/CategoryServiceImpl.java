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
import light.mvc.model.szl.Tcategory;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.Category;
import light.mvc.service.szl.CategoryServiceI;

@Service
public class CategoryServiceImpl implements CategoryServiceI {
	@Autowired
	private BaseDaoI<Tcategory> categoryDao;

	@Override
	public List<Category> dataGrid(Category category, PageFilter ph, SessionInfo sessionInfo) {
		List<Category> list = new ArrayList<Category>();
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tcategory t ";
		List<Tcategory> l = categoryDao.find(hql + whereHql(category, params, sessionInfo) + orderHql(ph), params,
				ph.getPage(), ph.getRows());
		for (Tcategory t : l) {
			Category c = new Category();
			BeanUtils.copyProperties(t, c);
			list.add(c);
		}
		return list;
	}

	@Override
	public Long count(Category category, PageFilter ph, SessionInfo sessionInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tcategory t ";
		return categoryDao.count("select count(*) " + hql + whereHql(category, params, sessionInfo), params);
	}

	private String whereHql(Category category, Map<String, Object> params, SessionInfo sessionInfo) {
		String hql = "";
		if (category != null) {
			hql += " where 1=1 ";
			
			if (category.getCategoryName() != null) {
				hql += " and t.categoryName like :categoryName";
				params.put("categoryName", "%%" + category.getCategoryName() + "%%");
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
	public void add(SessionInfo sessionInfo, Category category) {
		Tcategory c = new Tcategory();
		BeanUtils.copyProperties(category, c);
		c.setCreater(sessionInfo.getName());
		c.setCreateTime(new Date());
		categoryDao.save(c);
	}

	@Override
	public void delete(Long id, HttpServletRequest request) {
		Tcategory t = categoryDao.get(Tcategory.class, id);
		categoryDao.delete(t);
	}

	@Override
	public void edit(Category category) {
		Tcategory t = categoryDao.get(Tcategory.class, category.getId());
		t.setCategoryCode(category.getCategoryCode());
		t.setCategoryName(category.getCategoryName());
		t.setRemark(category.getRemark());
		categoryDao.update(t);
	}

	@Override
	public Category get(Long id) {
		Tcategory t = categoryDao.get(Tcategory.class, id);
		Category r = new Category();
		BeanUtils.copyProperties(t, r);
		return r;
	}

	@Override
	public List<Tree> tree() {
		List<Tcategory> l = null;
		List<Tree> lt = new ArrayList<Tree>();
		l = categoryDao.find("select distinct t from Tcategory t order by t.id");

		if ((l != null) && (l.size() > 0)) {
			for (Tcategory r : l) {
				Tree tree = new Tree();
				tree.setId(r.getId().toString());
				tree.setText(r.getCategoryName());
				lt.add(tree);
			}
		}
		return lt;
	}

}
