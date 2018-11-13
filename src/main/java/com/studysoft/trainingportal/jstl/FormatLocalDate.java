package com.studysoft.trainingportal.jstl;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import java.time.LocalDate;

import static com.studysoft.trainingportal.util.Utils.formatDate;

public class FormatLocalDate extends TagSupport {
    protected Object value;
    protected String var;

    public FormatLocalDate() {
        super();
        init();
    }

    private void init() {
        value = null;
        var = null;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public void setVar(String var) {
        this.var = var;
    }

    @Override
    public int doEndTag() throws JspException {
        if (value == null) {
            if (var != null) {
                pageContext.removeAttribute(var, PageContext.PAGE_SCOPE);
            }
            return EVAL_PAGE;
        }
        String formatted;
        if (value instanceof LocalDate) {
            formatted = formatDate((LocalDate) value);
        } else {
            throw new JspException("Value attribute must be instance of java.time.LocalDate," +
                    " was: " + value.getClass().getName());
        }
        Util.setAttributes(var, formatted, pageContext);
        return EVAL_PAGE;
    }

    public void release() {
        init();
    }

}
