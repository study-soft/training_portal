package com.company.training_portal.jstl;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
import java.time.Duration;

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
        Util.setAttributes(var, formatted, pageContext);
        return EVAL_PAGE;
    }

    public void release() {
        init();
    }

    private String formatDuration(Duration duration) {
        StringBuilder result = new StringBuilder();
        long totalSeconds = duration.toSeconds();
        int seconds = (int) totalSeconds % 60;
        int totalMinutes = (int) totalSeconds / 60;
        int minutes = totalMinutes % 60;
        int hours = totalMinutes / 60;
        result.append(hours == 0 ? "" : hours + ":")
                .append(minutes < 10 ? "0" : "")
                .append(minutes)
                .append(seconds < 10 ? ":0" : ":")
                .append(seconds);
        return result.toString();
    }
}
