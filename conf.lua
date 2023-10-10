function love.conf(t)
    t.title = 'taiko bird'
    t.version = '11.4'
    t.console = os.getenv('TAIKO_BIRD_ENV') == 'development'
    t.window = nil
end