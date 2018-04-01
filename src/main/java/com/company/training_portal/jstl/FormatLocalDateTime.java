package com.company.training_portal.jstl;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static com.company.training_portal.util.Utils.formatDateTime;
import static java.time.format.FormatStyle.MEDIUM;
import static java.time.format.FormatStyle.SHORT;

public class FormatLocalDateTime extends TagSupport {

    protected Object value;
    protected String var;

    public FormatLocalDateTime() {
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
        if (value instanceof LocalDateTime) {
            formatted = formatDateTime((LocalDateTime) value);
        } else {
            throw new JspException("Value attribute must be instance of java.time.LocalDateTime," +
                    " was: " + value.getClass().getName());
        }
        Util.setAttributes(var, formatted, pageContext);
        return EVAL_PAGE;
    }

    public void release() {
        init();
    }
}
