module ApplicationHelper
  def show_flash
    html = [:success, :error, :warn].collect do |key|
     "<div class='alert alert-#{key.to_s}'>" + 
     "<a class='close' data-dismiss='alert' href='#'>x</a>" +
     if key == :success
       ':)&nbsp;&nbsp;'
     elsif key ==:error
       ':(&nbsp;&nbsp;'
     else
       'Warning: &nbsp;&nbsp;'
     end +
     flash[key].to_s + "</div>" unless flash[key].blank?
    end.join
  end

end
