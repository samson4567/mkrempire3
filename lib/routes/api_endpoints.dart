
//----------IMAGE DIRECTORY---------//
String rootImageDir = "assets/images";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";
String rootSvgDir = "assets/svgs";

class ApiEndpoints {
  static const String appName = 'MKR Empire';

  //BASE_URL
  static const String baseUrl =
      'https://mkrempire.billway.ng/api'; // baseUrl/api

  static const String homeUrl =
      'https://mkrempire.billway.ng';

  //======= BILL PAYMENTS =====
  static const String pascribeEndpoint = '/payscribe';
  static const String airtimeUrl = '$pascribeEndpoint/airtime';
  static const String mobileDataLookupUrl = '$pascribeEndpoint/data-lookup';
  static const String buyMobileDataUrl = '$pascribeEndpoint/data-vending';
  static const String fetchServicesUrl = '$pascribeEndpoint/fetch-services';
  static const String validateBetAccountUrl =
      '$pascribeEndpoint/validate-bet-account';
  static const String validateElectricityUrl =
      '$pascribeEndpoint/validate-electricity';
  static const String payElectricityUrl = '$pascribeEndpoint/pay-electricity';
  static const String fundBetWallet = '$pascribeEndpoint/fund-bet-wallet';

  static const String fetchBettingServiceProvidersUrl =
      '$pascribeEndpoint/betting-service-provider-list';
  static const String getBanks = "/payscribe/get-bank-list";
  static const String getPins = '/payscribe/avaliable-epins';
//KYC
  static const String kycLookupUrl = '$pascribeEndpoint/kyc-lookup';
  static const String sendOtpUrl = '$pascribeEndpoint/send-kyc-otp';
  static const String verifyUrl = '$pascribeEndpoint/verify-kyc-otp';
  //END_POINTS_URL

  static const String adsUrl = '/ads';
  static const String registerUrl = '/register';
  static const String loginUrl = '/login';
  static const String loginWithPinUrl = '/login-with-pin';
  static const String forgotPassUrl = '/recovery-pass/get-email';
  static const String getBalance = '/payscribe/customer-balance';
  static const String updatePassUrl = '/update-pass';
  static const String resetPin = '/payscribe/reset-pin';
// GIGTCARD

  static const String getorderGiftCardUrl = '/gift-card/order';
  static const String getGiftcardsUrl = '/gift-card/products';
  static const String getGiftcardCountriesUrl = '/gift-card/get-countries';
  static const String getRedeemCodeUrl = '/gift-card/redeem-code';

  static const String appConfigUrl = '/app-config';
  static const String languageUrl = '/language';
  static const String profileUrl = '/profile';
  static const String profileUpdateUrl = '/profile-update';
  static const String profileImageUploadUrl = '/profile-update/image';
  static const String profilePassUpdateUrl = '/update-password';
  static const String emailUpdateUrl = '/email-update';
  static const String verificationUrl = '/verify';
  static const String identityVerificationUrl = '/kyc-submit';
  static const String twoFaSecurityUrl = '/2FA-security';
  static const String twoFaSecurityEnableUrl = '/2FA-security/enable';
  static const String twoFaSecurityDisableUrl = '/2FA-security/disable';
  static const String twoFaVerifyUrl = '/twoFA-Verify';
  static const String mailUrl = '/mail-verify';
  static const String smsVerifyUrl = '/sms-verify';
  static const String resendCodeUrl = '/resend-code';
  static const String pusherConfigUrl = "/pusher-config";

  static const String transactionUrl = '/transaction-list';
  static const String fundHistoryUrl = '/fund-list';
  static const String payoutListUrl = '/payout-list';
  static const String dashboardUrl = '/dashboard';

  //----virtual cards
  static const String virtualCardsUrl = "$pascribeEndpoint/create-card";
  static const String cardBlockUrl = "/virtual-card/block";
  static const String cardOrderForm = "/virtual-card/order";
  static const String cardOrderFormSubmit = "/virtual-card/order/submit";
  static const String cardOrderFormReSubmit = "/virtual-card/order/re-suPnbmit";
  static const String cardOrderConfirm = "/virtual-card/confirm";
  static const String cardTransaction = "/virtual-card/transaction";

  //----recipients
  static const String recipientsListUrl = "/recipient-list";
  static const String recipientdetailsUrl = "/recipient-details";
  static const String recipientNameUpdateUrl = "/recipient-update-name";
  static const String recipientDeleteUrl = "/recipient-delete";
  static const String getServicesUrl = "/get-services";
  static const String addRecipientUrl = "/recipient-store";

  //----money transfer
  static const String accountLookup = '/payscribe/account-lookup';
  static const String payoutFee = '/payscribe/payout-fee';
  static const String transfer = '/payscribe/transfer';
  static const String verifyTransfer = '/payscribe/verify-transfer';
  static const String createTempAccountUrl = '/payscribe/create-temporary-virtual-account';
  static const String varifyPaymentUrl = '/payscribe/verify-transaction';

  //----support ticket
  static const String supportTicketListUrl = '/ticket-list';
  static const String supportTicketCreateUrl = '/create-ticket';
  static const String supportTicketReplyUrl = '/reply-ticket';
  static const String supportTicketViewUrl = '/ticket-view';
  static const String supportTicketCloseUrl = '/close-ticket';

  //-----Payout
  static const String payoutUrl = "/payout-methods";
  static const String payoutRequestUrl = "/payout-request";
  static const String payoutSubmitUrl = "/payout-confirm";
  static const String getBankFromBankUrl = "/payout/get-bank/form";
  static const String getBankFromCurrencyUrl = "/payout/get-bank/list";
  static const String flutterwaveSubmitUrl = "/payout-confirm/flutterwave";
  static const String paystackSubmitUrl = "/payout-confirm/paystack";
  static const String payoutConfirmUrl = "/payout-confirm";

  //-----Add fund
  static const String gatewaysUrl = "/gateways";
  static const String manualPaymentUrl = "/addFundConfirm";
  static const String paymentRequest = "/payment-request";
  static const String onPaymentDone = "/payment-done";
  static const String webviewPayment = "/payment-webview";
  static const String cardPayment = "/card-payment";

  static const String notificationSettingsUrl = "/notification-settings";
  static const String notificationPermissionUrl = "/notification-permission";
  static const String referUrl = "/referral-list";

  //------wallet
  static const String walletStore = "/wallet-store";
  static const String defaultWallet = "/default-wallet";
  static const String walletTransaction = "/wallet-transaction";
  static const String moneyExchange = "/money-exchange";

  //-------money transfer request
  static const String getMoneyTransferRequest = "/money-request-form";
  static const String postMoneyTransferRequest = "/money-request";
  static const String moneyRequestHistory = "/money-request-list";
  static const String moneyRequestAction = "/money-request-action";
  static const String recipientstore = "/recipient-user-store";

  static const String deleteAccount = "/delete-account";





  //END_POINTS_URL

  static const String logoutUrl = '/logout';
  static const String sendUnauthenticatedMailUrl = '/send-unauthenticated-mail';
  static const String updatePinUrl = '/update-pin';



  // ****** Crypto Endpoints ********** //
  static const String getAllowedDepositCoinsUrl = '/get-allowed-deposit-coins';
  static const String getCoinInfoUrl = '/get-coin-info';
  static const String cryptoDepositUrl = '/crypto-deposit';
  static const String getMasterDepositAddressUrl = '/get-master-deposit-address';
  static const String cryptoWithdrawalUrl = '/crypto-withdraw';
  static const String getCryptoBalanceUrl = '/get-crypto-balance';
  static const String getSingleBalanceUrl = '/get-single-balance';
  static const String getRecordUrl = '/get-record';
  static const String getWalletBalanceUrl = '/get-wallet-balance';
  static const String getCryptoWithdrawalHistoryUrl = '/get-withdrawal-history';
  static const String getSwapCoinListUrl = '/query-coin-list';
  static const String requestSwapRateUrl = '/request-swap-rate';
  static const String swapUrl = '/swap';
  static const String getStakeProductInfoUrl = '/get-stake-product-info';
  static const String stakeCryptoUrl = '/stake-crypto';
  static const String getTickersUrl = '/get-tickers';
  static const String getMarketsUrl = '/get-markets';
  static const String getSingleCryptoInfoUrl = '/get-single-crypto-info';
  static const String getPlaceOrderUrl = 'place-order';
  static const String getBuyCryptos = '/cryptos/buy';
  static const String getSellCryptos = '/cryptos/sell';
  static const String getCryptos = '/cryptos';




  static const String fiatHistoryUrl = '/history';
  static const String getBanksUrl = '/cashonrails/get-banks';
  static const String getValidateUrl = '/cashonrails/validate';
  static const String withdrawFiatUrl = '/cashonrails/withdraw';
  //----money transfer
  static const String transferCurrencies = "/transfer-amount";
  static const String transferRecipient = "/transfer-recipient";
  static const String transferReview = "/transfer-review";
  static const String transferPaymentStore = "/transfer-payment-store";
  static const String transferPost = "/money-transfer-post";
  static const String transferHistory = "/transfer-list";
  static const String transferPay = "/transfer-pay";
  static const String transferDetails = "/transfer-details";
  static const String currencyRate = "/currency-rate";
  static const String transferOtp = "/transfer-otp";





}

