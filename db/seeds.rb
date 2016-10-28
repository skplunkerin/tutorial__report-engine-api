# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Our first engine to test with
engine=Engine.create({
  name: "IXD Reports", 
  status: "active"
})

# Create all our roles
roles = ['api', 'admin', 'reporter', 'client']
roles.each do |role|
  Role.create({
    name: role
  })
end

# 'api' and 'client' roles
role_api=Role.find_by_name('api')
role_client=Role.find_by_name('client')
role_reporter=Role.find_by_name('reporter')
role_admin=Role.find_by_name('admin')

# our first 'api' user
user_api=User.create({
  engine_id: engine.id, 
  name: "API User", 
  email: "api@example.com", 
  password: "Steve1",
  password_confirmation: "Steve1",
  status: "active", 
  notes: "Testing user creation with API access"
})

# Give 'api' role to user_api
user_api.roles << role_api

# our first 'admin' user
user_admin=User.create({
  engine_id: engine.id, 
  name: "Admin User", 
  email: "admin@example.com", 
  password: "Steve1",
  password_confirmation: "Steve1",
  status: "active", 
  notes: "Testing user creation with Admin access"
})

# Give 'client' role to user_client
user_admin.roles << role_admin

# our first 'reporter' user
user_reporter=User.create({
  engine_id: engine.id, 
  name: "Reporter User", 
  email: "reporter@example.com", 
  password: "Steve1",
  password_confirmation: "Steve1",
  status: "active", 
  notes: "Testing user creation with Reporting access"
})

# Give 'reporter' role to user_reporter
user_reporter.roles << role_reporter

# our first 'client' user
user_client=User.create({
  engine_id: engine.id, 
  name: "Client User", 
  email: "client@example.com", 
  password: "Steve1",
  password_confirmation: "Steve1",
  status: "active", 
  notes: "Testing user creation with Client access"
})

# Give 'client' role to user_client
user_client.roles << role_client

# Create property for our client
p1=Property.create({
  engine_id: engine.id,
  user_id: user_client.id,
  name: "http://example.com",
  status: "active"
})

# Create property for our client
p2=Property.create({
  engine_id: engine.id,
  user_id: user_client.id,
  name: "http://sample.com",
  status: "active"
})

# Share these properties with Admin user
user_admin.properties << user_client.owned_properties

# Create basic report for Property 1
r1=Report.create({
  property_id: p1.id,
  name: "Initial Review",
  summary: "We've found that we're missing some basic SEO content, and a few other things that we can add",
  status: "draft",
  publish_date: "2016/10/28 08:00:00".to_datetime,
  version: "1.0.0",
  notes: "Waiting for analytics to start collecting data"
})
# Add 2 sections to our report
s1=Section.create({
  report_id: r1.id,
  order: 0,
  name: "Homepage",
  status: "active",
  content: "<div class=\"float-left\">
              <h2>It looks like our main CTA will need to stay above-the-fold, few users scroll past that point</h2>
              <p>We can see on the right that the main content users see might not be what we're wanting them to see:</p>
            </div>
            <div class=\"float-right\">
              <img class=\"tall-image\" src=\"../home-shots/cta-needed.jpg\" />
            </div>"
})
s2=Section.create({
  report_id: r1.id,
  order: 1,
  name: "(WIP) - Mobile",
  status: "active",
  content: "<h1>The following section reports solely on mobile visitors (users on a Tablet, Phone, etc).</h1>"
})

# Output some APIKEY's for us to use for Postman testing
p "Engine APIKEY: #{engine.apikey}"
p "API User APIKEY: #{user_api.apikey}"
p "Admin User APIKEY: #{user_admin.apikey}"
p "Reporter User APIKEY: #{user_reporter.apikey}"
p "Client User APIKEY: #{user_client.apikey}"
