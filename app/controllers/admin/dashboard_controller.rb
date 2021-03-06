class Admin::DashboardController < Admin::AdminController

  def index
    dashboard_data = Rails.cache.fetch("admin-dashboard-data-#{Discourse::VERSION::STRING}", expires_in: 1.hour) do
      AdminDashboardData.fetch_all.as_json
    end
    dashboard_data.merge!({version_check: DiscourseUpdates.check_version.as_json}) if SiteSetting.version_checks?
    render json: dashboard_data
  end

  def problems
    render_json_dump({problems: AdminDashboardData.fetch_problems})
  end
end
