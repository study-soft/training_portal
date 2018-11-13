package com.studysoft.trainingportal.jstl;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.PageContext;
import java.io.IOException;

public class Util {
    public static void setAttributes(String attribute, Object value, PageContext pageContext) throws JspTagException {
        if (attribute != null) {
            pageContext.setAttribute(attribute, value, PageContext.PAGE_SCOPE);
        } else {
            try {
                pageContext.getOut().print(value);
            } catch (IOException e) {
                throw new JspTagException(e.toString(), e);
            }
        }
    }
}
