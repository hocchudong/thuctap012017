# Introduction Keystone

# MỤC LỤC





<a name="modau"></a>
# Mở đầu
Một khía cạnh quan trọng để thiết lập cloud, cho dù nó là private, public, hoặc dedicated, là đảm bảo việc access đến cloud resources và security được áp dụng. Trong OpenStack evironments, project cho securing là Keystone, OpenStack’s Identity service. Keystone cung cấp nhiều chức năng chính, như authenticating user và determining resource user được phép access.  

<a name="1"></a>
# 1.Identity, Authentication, and Access Management Capabilities of Keystone
Cloud environments at the Infrastructure-as-a-Service layer (IaaS) provide users access to key resources such as virtual machine instances, large amounts of block and object storage, and network bandwidth. A critical feature of any cloud environment is how it provides secure, controlled access to these valuable resources. In OpenStack environments, the Keystone service is responsible for providing secure controlled access to all of the cloud’s resources. Keystone has proven itself to be a vital component for a secure cloud.  
Keystone provides secure and controlled access to OpenStack Cloud resources we need to examine Keystone’s fundamental capabilities for providing Identity, Authentication, and Access Management. The following sections provide short overviews of these core Keystone capabilities.  

<a name="2"></a>
# 2.Identity
Identity refers to the identification of who is trying to access cloud resources. In OpenStack Keystone, identity is typically represented as a user. In simple deploy‐ ments, the identity of a user can be stored in Keystone’s own database. In production or enterprise environments, an external Identity Provider is commonly used. An example of this is IBM’s Tivoli Federated Identity Manager. Keystone should be able to retrieve the user’s identity information from these external Identity Providers.  

<a name="3"></a>
# 3.Authentication
Authentication là quá trính xác thực user’s identity. Trong nhiều trường hợp, authentication được thực hiện bởi user thực hiện login với user identity và password. Trong OpenStack environment đơn giản, Keystone có khả năng thực hiện tất cả các bước authentication. Điều này không được khuyến cáo cho môi trường production hoặc enterprise. Cho real environment, passoword cần được bảo vệ và quản lý đúng cách, Keystone is pluggable such that it easily integrates with an existing hardened production authentication service, such as LDAP or Active Directory.  
Mặc dù user identity ban đầu được authenticated với password, nó là rất phổ biến như một phần của của quá trình authentication ban đầu để tạo token cho việc authentication này. Điều này làm giảm số lần visibility and exposure của password mà chúng ta cần che giấu và bảo vệ. Token cũng có limited lifespan và hết hạn để tính hữu dụng của chúng limited nếu chúng bị stolen. Openstack dựa vào token cho authentication và các mục đích khác, và Keystone là một trong những service duy nhất được issue them. Hiện tại Keystone sử dụng form của token gọi là “bearer token”. Điều này nghĩa là bất kì ai sở hữu token, properly or improperly (i.e., stolen) đều có khả năng sử dụng token để authenticate và access resource. Như vậy, Keystone là rất quan trọng trong việc bảo vệ token và them contents.  

<a name="4"></a>
# 4.Access Management (Authorization)
Khi user identity được authenticaed và token được tạo ra và allocated, mọi thứ bắt đầu thú vị.Điều này bởi vì chúng ta đã có đủ cơ sở để thực hiện Access Management.
Accerss Management (Authorization) là quá trình determining resource user được quyền access. Cloud environment như OpenStack provide user với acceses đến large resource.
Ví dụ: Cần phải có một cơ chế để determining users allowed create new instance của virtual machine, cụ thể, user allowed attach hoặc delete volume của block storage mà user allowed để create virtual networks, etc. Trong OpenStack, Keysonte maps Users đến Project hoặc Domains bởi associating a Role cho for the Project or Domain. 
Một số OpenStack subprojects như Nova, Cinder, và Neutron xem xét User’s Project và Role associations và đánh giá information sử dụng policy engine. The policy engine kiểm tra information (đặc biệt là Role vaule) và determination về actione user allowed thi hành.

<a name="4"></a>
# 5.Keystone’s Primary Benefits
Keystone chủ yếu tập trung providing Identity, Authentication, and Access Management, nó procide một lượng lớn các lợi ích cho OpenStack environment. Lợi ích chính bao gồm :  
- Keystone’s Primary BenefitsSingle Authentication and Access Management interface for other OpenStack services. Keystone handles the complex tasks of integrating with externalAuthentication systems and also provides uniform Access Management for all the other OpenStack services, such as Nova, Glance, Cinder, Neutron, etc., and thus Keystone isolates all the other services from knowing how to talk to different identity and authorization providers.
- Keystone provides a registry of containers (“Projects”) that other OpenStack services can use to segregate resources (e.g., servers, images, etc.).
- Keystone provides a registry of Domains that are used to define separate nam spaces for users, groups, and projects to allow segregation between customers.
- A registry of Roles that will be used for authorization between Keystone and the policy files of each of the OpenStack services.
- An assignment store allowing users and groups to be assigned roles on projects and domains.
- A catalog storing OpenStack services, endpoints, and regions, allowing clients to discover the service or endpoint they need.






















