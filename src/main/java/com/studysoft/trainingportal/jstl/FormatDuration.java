package com.studysoft.trainingportal.jstl;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import java.time.Duration;

import static com.studysoft.trainingportal.util.Utils.formatDuration;

public class FormatDuration extends TagSupport {

    protected Object value;
    protected String var;

    public FormatDuration() {
        super();
        init();
    }

    private void init() {
        var = null;
        value = null;
    }

    public void setVar(String var) {
        this.var = var;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public int doEndTag() throws JspException {
        if (value == null) {
            if (var != null) {
                pageContext.removeAttribute(var, PageContext.PAGE_SCOPE);
            }
            return EVAL_PAGE;
        }

        String formatted;
        if (value instanceof Duration) {
            formatted = formatDuration((Duration) value);
        } else {
            throw new JspException("Value attribute must be instance of java.time.Duration," +
            " was: " + value.getClass().getName());
        }
        JstlUtils.setPageAttributes(var, formatted, pageContext);
        return EVAL_PAGE;
    }

    public void release() {
        init();
    }
}
