package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mvc.command.service.ListService;
import mvc.domain.dto.PageResultDTO;

public class ListHandler implements CommandHandler {
    private static final int DEFAULT_PAGE_SIZE = 10;
    private ListService service = new ListService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");

        int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
        int size = sizeParam != null ? Integer.parseInt(sizeParam) : DEFAULT_PAGE_SIZE;

        PageResultDTO dto = service.getPageResult(page, size, searchType, keyword);

        request.setAttribute("list", dto.getList());
        request.setAttribute("totalCount", dto.getFulllist().size());
        request.setAttribute("fulllist", dto.getFulllist());
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("searchType", searchType);
        request.setAttribute("keyword", keyword);

        return "page.jsp";
    }
}