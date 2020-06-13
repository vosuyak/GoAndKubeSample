# Define the base image
FROM golang:1.14.1
# Create an app directory to hold container sources
RUN mkdir /app
# Copy EVERYTHING from the root, to the container (local -> container)
ADD . /app
# Officially define the work app location 
WORKDIR /app
# Build the app into binary
RUN go build -o main .
# Run the binary executable ( workdir / main.go !.go)
CMD ["/app/main"]

# ** Creating a docker image, and running it ** 
# Create image
# Create repo in your repository (Docker Hub)
# docker build -t <repository username>/<image-name>:<tag-name> .
# Run image -it for interactive mode, -p amps the port on which Go is running : on container
# docker run -it -p <appport>:<containerport> <image>

# manifest - Kubernetes object description file, This manifest will contain all of the configuration
    # details needed to deploy your Go app to your cluster.
# For bigger projects it's best to store mainifestes in a seperate subdirectoy to keep organization

# To make pubulicly accessible, we will need to deploy the new imafe to
# the kubernetes cluster using kubectl
# kubernetes objects is RESTful resouses, also seen as the work orders submited to kubernetes
    # you list what resources you need and how they should work, and then Kubernetes will constantly 
    # work to ensure that they exist in your cluster.

# DEPLOYMENT: Kubernetes object, known as a deployment, is a set of identical, indistinguishable pods. 
    # In Kubernetes, a pod is a grouping of one or more containers which are able to communicate over the 
    # same shared network and interact with the same shared storage. A deployment runs more than one replica
    # of the parent application at a time and automatically replaces any instances that fail, ensuring that
    # your application is always available to serve user requests.
    # *metadata: field is required for every Kubernetes object as it contains information such as the unique 
    # name of the object. This name is useful as it allows you to distinguish different deployments from one 
    # another and identify them using names that are human-readable
    # *spec field is a requirement for every Kubernetes object, but its precise format differs for each type 
    # of object. In the case of a deployment, it can contain information such as the number of replicas of you want to run.
    # *replica is the number of pods you want to run in your cluster.
    # *selector block nested under the spec block. This will serve as a label selector for your pods. Kubernetes 
    # uses label selectors to define how the deployment finds the pods which it must manage.
    # * template block. Every deployment creates a set of pods using the labels specified in a template block
    # * spec block. This is different from the spec block you added previously, as this one applies only to the pods created by the template block
    # * containers field and once again define a name attribute. This name field defines the name of any containers created by this particular deployment. 
    # Below that, define the image you want to pull down and deploy.
    # * imagePullPolicy field set to IfNotPresent which will direct the deployment to only pull an image if it has not already done so before
    # * ports block. There, define the containerPort which should match the port number that your Go application listens on
    
# SERVICE: This service will expose the same port on all of your cluster’s nodes. Your nodes will then forward any incoming traffic on that port to the pods running your application.
    # apiVersion and the kind fields in a similar fashion to your deployment
    # * metasata: add the name of your service in a metadata block     
    # * spec block will be different than the one included in your deployment, and it will contain the type of 
    # this service, as well as the port forwarding configuration and the selector
    # * type and set it to LoadBalancer. This will automatically provision a load balancer that will act as the main entry point to your application.
    # * ports block where you’ll define how you want your apps to be accessed. 
        # This will take incoming HTTP requests on port 80 and forward them to the targetPort of 3000(container)
        # selector block is important, as it maps any deployed pods named go-web-app to this service
    # will apply the new Kubernetes service as well as create a load balancer. This load balancer will serve as the public-facing entry point to your application running within the 
    # clusterwill apply the new Kubernetes service as well as create a load balancer. This load balancer will serve as the public-facing entry point to your application running within the cluster
    # * EXTERNAL-IP column and copy the IP address associated with the go-web-service
    # The load balancer will take in the request on port 80 and forward it to one of the pods running within your cluster.
    # you’ve created a Kubernetes service coupled with a load balancer, giving you a single, stable entry point to application.
    # Moving forward, you could map your load balancer’s IP address to a domain name that you control so that you can access the application through a human-readable web address rather than the load balancer IP