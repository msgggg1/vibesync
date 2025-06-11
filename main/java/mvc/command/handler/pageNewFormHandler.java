// mvc/command/handler/pageNewFormHandler.java
package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** 새 페이지 생성 폼을 반환 */
public class pageNewFormHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println(
            "<div class=\"modal-content\">"
          + "  <h3>새 페이지 생성</h3>"
          + "  <form id=\"pageCreateForm\" enctype=\"multipart/form-data\">"
          + "    <label>Subject: <input type=\"text\" name=\"subject\" required/></label><br/>"
          + "    <label>Thumbnail: <input type=\"file\" name=\"thumbnail\" accept=\"image/*\" required/></label><br/>"
          + "    <button type=\"submit\">Create</button>"
          + "  </form>"
          + "</div>"
        );
        return null;
    }
}
