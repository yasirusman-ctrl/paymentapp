every 1.day, at: "8:00 am" do
  runner "CheckSubscriptionExpirationJob.perform_later"
end
