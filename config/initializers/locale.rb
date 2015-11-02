I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# set default locale to something other than :en
#I18n.default_locale = 'ru-RU'
I18n.available_locales = %w(ru en)
I18n.default_locale = :ru