module ApplicationHelper
    def active? options
        if current_page? options
            "active"
        else
            ""
        end
    end
end
