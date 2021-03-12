module ApplicationHelper
    def user_avatar(user, size)
        if user.avatar.attached?
            image_tag(user.avatar.variant(resize: "#{size}x#{size}!"))
        else
            image_tag("user-icon.jpg", size: "#{size}x#{size}")
        end
    end
end