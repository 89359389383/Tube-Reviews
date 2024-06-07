module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }
  end

  def truncate_lines(text, lines: 2, length: 20, ellipsis: '...')
    return '' if text.blank?

    truncated_text = text.split("\n").first(lines).map { |line| line.truncate(length) }.join("\n")
    
    if text.split("\n").size > lines || text.length > length * lines
      truncated_text += ellipsis
    end

    simple_format(truncated_text)
  end
end
