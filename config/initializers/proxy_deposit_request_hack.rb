::ProxyDepositRequest.class_eval do
  private
  def send_request_transfer_message_as_part_of_create
    user_link = link_to(sending_user.name, Hyrax::Engine.routes.url_helpers.user_url(sending_user))
    transfer_link = link_to('transfer requests', Hyrax::Engine.routes.url_helpers.transfers_url)
    message = "#{user_link} wants to transfer a work to you. Review all #{transfer_link}"
    Hyrax::MessengerService.deliver(sending_user, receiving_user, message, "Ownership Change Request")
  end

  def send_request_transfer_message_as_part_of_update
	message = I18n.t('hyrax.notifications.proxy_deposit_request.transfer_on_update.message', status: status)
	if receiver_comment.present?
	  message += " " + I18n.t('hyrax.notifications.proxy_deposit_request.transfer_on_update.comments',
				  receiver_comment: receiver_comment)
	end
	Hyrax::MessengerService.deliver(receiving_user, sending_user, message,
					I18n.t('hyrax.notifications.proxy_deposit_request.transfer_on_update.subject',
					       status: status))
      end
end