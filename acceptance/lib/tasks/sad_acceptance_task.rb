def deliberate_failure(expected_class, expected_message=nil)
  ooops = false
  begin
    yield
    ooops = true
  rescue Exception => e
    if expected_class != e.class
      raise RuntimeError, "expected #{expected_class}, but got #{e.class} (#{e})", e.backtrace
    elsif expected_message && expected_message != e.to_s
      raise e
    end
  end
  fail "Task should have thrown a failure" if ooops  
end
