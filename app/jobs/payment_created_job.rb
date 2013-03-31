class PaymentCreatedJob < Struct.new(:payment_id, :community_id)
  
  include DelayedAirbrakeNotification
  
  # This before hook should be included in all Jobs to make sure that the service_name is 
  # correct as it's stored in the thread and the same thread handles many different communities
  # if the job doesn't have community_id parameter, should call the method with nil, to set the default service_name
  def before(job)
    # Set the correct service name to thread for I18n to pick it
    ApplicationHelper.store_community_service_name_to_thread_from_community_id(community_id)
  end
  
  def perform
    payment = Payment.find(payment_id)
    community = Community.find(community_id)
    if payment.recipient.should_receive?("email_about_new_payments")
      PersonMailer.new_payment(payment, community).deliver
    end
    Delayed::Job.enqueue(ConfirmReminderJob.new(payment.conversation.id, conversation.requester.id, community_id, 0), :priority => 0, :run_at => 1.week.from_now)
  end
  
end