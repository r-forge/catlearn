#include <vector>
#include <map>
#include <iostream>
#include <cmath>
#include <sstream>
#include <string>

#define float long double

float comb(int p,int k)
{
//  std::cerr<<"C("<<p<<","<<k<<")=";
  float ans=1;
  for(int i=1;i<=k;++i,--p)
  {
//    std::cerr<<"("<<p<<"/"<<i<<")";
    ans*=(float)(p)/i;
  }
//  std::cerr<<"="<<ans<<"\n";
  return ans;
}

float fact(int p)
{
  float f=1.;
  for(;p>1;--p)
  { f*=p;
  }
  return f;
}

  float xrawprob2(float q, float r,int n,int nnp, int nnm,float length)
  {
    float ret=std::pow(1.-std::exp(-q*length),nnp)
              *std::pow(std::exp(-q*length),n-nnp)
#ifndef PERC_ELS_ONLY
              *std::pow(1.-std::exp(-r*length),nnm)
              *std::pow(std::exp(-r*length),n-nnm)
#endif              
              ;
//    std::cerr<<q<<" "<<num_perc()<<" "<<r<<" "<<num_mem
//    for(int i=depth();i>1;--i) ret/=i;
    return ret;
  }

struct state
{
  state(int nel):nel_(nel),perc_(nel,false),mem_(nel,false),stop_(false),np_(0),nm_(0),nx_(0)
  {}

  float rawprob(float q, float r,float length)const
  {
    float ret=std::pow(1.-std::exp(-q*length),num_perc())
#ifndef PERC_ELS_ONLY
    *std::pow(1.-std::exp(-r*length),num_mem())
#endif
    ;
//    std::cerr<<q<<" "<<num_perc()<<" "<<r<<" "<<num_mem
//    for(int i=depth();i>1;--i) ret/=i;
    return ret;
  }

  float rawprob2(float q, float r,float length)const
  {
    float ret=std::pow(1.-std::exp(-q*length),num_perc())
              *std::pow(std::exp(-q*length),nel_-num_perc())
#ifndef PERC_ELS_ONLY
              *std::pow(1.-std::exp(-r*length),num_mem())
              *std::pow(std::exp(-r*length),nel_-num_mem())
#endif              
              ;
//    std::cerr<<q<<" "<<num_perc()<<" "<<r<<" "<<num_mem
//    for(int i=depth();i>1;--i) ret/=i;
    return ret;
  }


  float rawprob3(float q, float r,float length)const
  {
    float ret=std::pow(1.-std::exp(-q*length),num_perc())
              *std::pow(std::exp(-q*length),nel_-num_perc())
#ifndef PERC_ELS_ONLY
              *std::pow(1.-std::exp(-r*length),num_mem())
              *std::pow(std::exp(-r*length),nel_-num_mem())
              /fact(num_perc()+num_mem())
#else
              /fact(num_perc())
#endif              
              ;
//    std::cerr<<q<<" "<<num_perc()<<" "<<r<<" "<<num_mem
//    for(int i=depth();i>1;--i) ret/=i;
//     ret*=(num_perc()+num_mem());
//     std::cerr<<ret<<"\n";
     return ret;
  }

  float integral1(float q, float r,int n,int nnp, int nnm, float length)const
  {
//    output(std::cerr);
//    std::cerr<<"; etime: "<<num_perc()<<" @ "<<q<<", "<<num_mem()<<" @ "<<r<<", "<<length<<":  ";
  
if(nnp<0) return 0;
if(nnm<0) return 0;
#ifdef PERC_ELS_ONLY
    int nm=0;
#else
    int nm=n;
#endif
    float et=length;//*xrawprob2(q,r,n,nnp,nnm,length); // x - x P(X>z) == x(1 - P(X>z)) = x P(X<z)
//    std::cerr<<et;
    for(int k=0;k<=nnp;++k)
    {
      const int k2=n-nnp+k;
      for(int l=0;l<=nnm;++l)
      {
        const int l2=nm-nnm+l;
        if((k2+l2)==0) 
        {
//          std::cerr<<" - "<<length;
          et-=length;
        }
        else 
        {
//          std::cerr<<"\n"<<comb(num_perc(),k)<<","<<comb(num_mem(),l)<<"\n";

        
          float temp1=comb(nnp,k)
                      *comb(nnm,l)
                      ;
          float temp2=(std::exp(-(q*k2+r*l2)*length)-1.)/(q*k2+r*l2);
//          std::cerr<<(((k+l)%2==1)?" - ":" + ");
//          std::cerr<<"["<<k<<","<<l<<";"<<k2<<","<<l2<<"] "<<temp1<<" * "<<temp2;

          if((k+l)%2==1) temp1=-temp1;
          et+=temp1*temp2;
        }
      }
    }
//#else
//#endif

//    std::cerr<<" = "<<et<<"; adj=";
//    et/=xrawprob2(q,r,n,nnp,nnm,length);
//    std::cerr<<et<<"\n";
    return et;
  }
  
  float integral1a(float q, float r,int n,int nnp, int nnm, float length)const
  {
//    output(std::cerr);
//    std::cerr<<"; etime: "<<num_perc()<<" @ "<<q<<", "<<num_mem()<<" @ "<<r<<", "<<length<<":  ";
  
#ifdef PERC_ELS_ONLY
    int nm=0;
#else
    int nm=n;
#endif
    float et=0;//length;//*xrawprob2(q,r,n,nnp,nnm,length); // x - x P(X>z) == x(1 - P(X>z)) = x P(X<z)
//    std::cerr<<et;
    for(int k=0;k<=nnp;++k)
    {
      const int k2=n-nnp+k;
      for(int l=0;l<=nnm;++l)
      {
        const int l2=nm-nnm+l;
        if((k2+l2)==0) 
        {
//          std::cerr<<" - "<<length;
          et+=length;
        }
        else 
        {
//          std::cerr<<"\n"<<comb(num_perc(),k)<<","<<comb(num_mem(),l)<<"\n";

        
          float temp1=comb(nnp,k)
                      *comb(nnm,l)
                      ;
          float temp2=(std::exp(-(q*k2+r*l2)*length)-1.)/(q*k2+r*l2);
//          std::cerr<<(((k+l)%2==1)?" - ":" + ");
//          std::cerr<<"["<<k<<","<<l<<";"<<k2<<","<<l2<<"] "<<temp1<<" * "<<temp2;

          if((k+l)%2==0) temp1=-temp1;
          et+=temp1*temp2;
        }
      }
    }
//#else
//#endif

//    std::cerr<<" = "<<et<<"; adj=";
//    et/=xrawprob2(q,r,n,nnp,nnm,length);/
//    std::cerr<<et<<"\n";
    return et;
  }

  float integral2(float q, float r,int n,int nnp, int nnm, float length)const
  {
//    output(std::cerr);
//    std::cerr<<"; etime: "<<num_perc()<<" @ "<<q<<", "<<num_mem()<<" @ "<<r<<", "<<length<<":  ";
  
#ifdef PERC_ELS_ONLY
    int nm=0;
#else
    int nm=n;
#endif
    if(nnm<0) return 0;
    if(nnp<0) return 0;
//    std::cerr<<"; integral2: "<<nnp<<" @ "<<q<<", "<<nnm<<" @ "<<r<<", "<<length<<":  ";
    float et=0;//length*length/2;//length;//*xrawprob2(q,r,n,nnp,nnm,length); // x - x P(X>z) == x(1 - P(X>z)) = x P(X<z)
//    std::cerr<<et;
    for(int k=0;k<=nnp;++k)
    {
      const int k2=n-nnp+k;
      for(int l=0;l<=nnm;++l)
      {
        const int l2=nm-nnm+l;
        if((k2+l2)==0) 
        {
//          std::cerr<<" - "<<length;
          et+=length*length/2;
        }
        else 
        {
//          std::cerr<<"\n"<<comb(num_perc(),k)<<","<<comb(num_mem(),l)<<"\n";

        
          float temp1=comb(nnp,k)
#ifndef PERC_ELS_ONLY
                      *comb(nnm,l)
#endif
                      ;
          float temp2=(std::exp(-(q*k2+r*l2)*length)-1.)/((q*k2+r*l2)*(q*k2+r*l2));
          temp2+=(length)/(q*k2+r*l2);
          if((k+l)%2==0) temp2=-temp2;
//          std::cerr<<(((k+l)%2==1)?" - ":" + ");
//          std::cerr<<"["<<k<<","<<l<<";"<<k2<<","<<l2<<"] "<<temp1<<" * "<<temp2;

          et+=temp1*temp2;
        }
      }
    }
//#else
//#endif

//    std::cerr<<" = "<<et<<"; adj=";
//    et/=xrawprob2(q,r,n,nnp,nnm,length);
//    std::cerr<<et<<"\n";
    return et;
  }

  float etime(float q, float r, float length) const
  {
    float pless=
               q*num_perc()*integral1a(q,r,nel_,num_perc()-1,num_mem(),length)+
               r*num_mem ()*integral1a(q,r,nel_,num_perc(),num_mem()-1,length);
//    std::cerr<<num_perc()<<","<<num_mem()<<","<<pless             <<"\n";

     float a= length*(pless); // length - length * pmore
     float b=q*num_perc()*integral2(q,r,nel_,num_perc()-1,num_mem(),length); // integral pless
     float c=r*num_mem ()*integral2(q,r,nel_,num_perc(),num_mem()-1,length); // integral pless



//    std::cerr<<num_perc()<<" "<<a<<" "<<b/fudge<<" "<<c/fudge<<" "<<fudge<<"\n";

//    fudge=0;

    return (a)/(pless)+(b+c)/(pless);
  }

  void add_perc(int i)
  {
    if(!perc_[i])
    {
      perc_[i]=true;
      np_++;
      if(mem_[i]) ++nx_;
    }
//    std::stringstream ss;
//    ss<<path<<"P("<<i<<")_";
//    path=ss.str();
  }
  
  int num_perc()const{return np_;}

  bool perc(int i)const{return perc_[i];}
  
  void add_mem(int i)
  {
    if(!mem_[i])
    {
      mem_[i]=true;
      nm_++;
      if(perc_[i]) ++nx_;
    }
//    std::stringstream ss;
//    ss<<path<<"M("<<i<<")_";
//    path=ss.str();
  }

  int num_mem()const{return nm_;}

  bool mem(int i)const{return mem_[i];}

  int depth()const{return num_perc()+num_mem();}

  float fd()const
  {
//    return 1;
//    std::stringstream ss;
//    ss<<path;
//    std::cerr<<nel_<<path<<"   ";
    float cock=
    //  comb(nel_,num_match())*comb(nel_-num_match(),num_mem()-num_match())*comb(nel_-num_match()-num_mem(),num_perc()-num_match())*
    fact(depth());
//    ss<<"X"<<cock;//<<"\n";
//    path=ss.str();
    return cock;  
  }

  bool stopped()const
  {
    return stop_;
  }

  void stop()
  {
    stop_=true;
    
//    std::stringstream ss;
//    ss<<path<<"S";
//    path=ss.str();
  }

  int num_match()const
  {
#ifndef PERC_ELS_ONLY
    return nx_;
#else
    return np_;
#endif
  }
  
  std::ostream&output(std::ostream&os)const
  {
    return os<<"["<<num_perc()<<"/"<<num_mem()<<"/"<<stopped()<<"/"<<path<<"]";
  }

  bool operator<(const state&y)const
  {
    if(num_perc()<y.num_perc()) return true;
    if(num_perc()>y.num_perc()) return false;
    if(num_mem()<y.num_mem()) return true;
    if(num_mem()>y.num_mem()) return false;
    if(stopped()<y.stopped()) return true;
    if(stopped()>y.stopped()) return false;
//    if(path<y.path)return true;
    return false;
  }

  int num()const{return nel_;}

  private:

  int nel_;
  std::vector<bool> perc_,mem_;
  int np_,nm_,nx_;
  bool stop_;
  
  mutable std::string path;
};

std::ostream&operator<<(std::ostream&os,const state&st)
{
  return st.output(os);
}

struct params
{
  int nel,n;
  float c,q,q2,r,l,th;
};

float sim(const state&st,int stim,int resp,const params&p)
{
  return std::exp(-p.c*std::abs(stim-resp)*
#ifdef NO_DIR
  st.num_match() ///static_cast<float>(st.num())
#else
  (1-std::pow(p.l,st.num_match()))
#endif
  );
}

float prr(const state&st,int stim,int resp,const params& p)
{
  float bot=0.;

  for(int i=0;i<p.n;++i)
  {
    float s=std::pow(sim(st,stim,i,p),p.th);
    bot+=s;
  }
  
  return std::pow(sim(st,stim,resp,p),p.th)/bot;
}

float prc(const state&st,int stim,const params& p)
{
  return prr(st,stim,stim,p);
}

struct stoc
{
  stoc():p(0),rt(0){}

  stoc(float q,float r):p(q),rt(r){}

  float p;
  float rt;
  
  stoc& operator+=(const stoc&x)
  {
    rt=(rt*p+x.rt*x.p)/(p+x.p);
    p+=x.p;
    return *this;
  }
  
  std::ostream&output(std::ostream&os)const
  {
    return os<<p<<"\t"<<rt;
  }
};

std::ostream& operator<<(std::ostream&os,const stoc&s)
{
  return s.output(os);
}

typedef std::map<state,stoc> events;

std::ostream& operator<<(std::ostream&os,const std::pair<const state,stoc>&x)
{
  return os<<x.first<<"\t"<<x.second;
}

std::ostream& operator<<(std::ostream&os,const events&x)
{
  float tot=0.;
  for(std::map<state,stoc>::const_iterator i=x.begin();i!=x.end();++i)
  {
    tot+=i->second.p;
    os<<*i<<"\n";
  }
  return os<<tot<<"\n";;
}


float pstop(const state& st,int stim,const params&p)
{
#ifndef PERC_ELS_ONLY
  if(st.num_mem()==0) return 0;
//  if((st.num_perc()==0)&&(st.num_mem()==0)) return 0;

  if(/*(p.nel==st.num_perc())&&*/(p.nel==st.num_mem())) return 1;
#else
  if(st.num_perc()==0) return 0;
//  if((st.num_perc()==0)&&(st.num_mem()==0)) return 0;

  if(/*(p.nel==st.num_perc())&&*/(p.nel==st.num_perc())) return 1;
#endif
//  return .25;

  float top=0.,bot=0.;

  for(int i=0;i<p.n;++i)
  {
    float s=sim(st,stim,i,p);
    top+=std::pow(s,p.th);
    bot+=s;
  }
  
  return top/std::pow(bot,p.th);
}

float snake(const state& st,float q,float r,float length)
{
   return  st.rawprob3(q,r,length);
}


void first_stage_rec(events& ev,state st,float inprob,float length,int stim,const params&p,float inprob2,bool perc=false)
{
#ifdef PERC_ELS_ONLY
  perc=false;
#endif
  float ps=perc?0:pstop(st,stim,p);
#ifdef FIRST_STAGE_NO_STOP
  ps=ps==1?1:0;
#endif
  if(ps!=0)
  {
  state ltemp=st;
  ltemp.stop();
  stoc badger(inprob*ps,st.etime(p.q,p.r,length));
  ev[ltemp]+=badger; 
  }
  if(ps==1.) return;
  inprob*=(1.-ps);
  inprob2*=(1.-ps);
  
  float mysnake = inprob2*snake(st,p.q,p.r,length);///inprob2;//std::exp(-length*(p.q*(p.nel-st.num_perc())+p.r*(p.nel-st.num_mem())));
//  std::cerr<<mysnake<<"\n";
#ifndef PERC_ELS_ONLY
  float pelp=p.q/(p.q*(p.nel-st.num_perc())+p.r*(p.nel-st.num_mem()));
  float pelm=p.r/(p.q*(p.nel-st.num_perc())+p.r*(p.nel-st.num_mem()));
#else
  float pelp=1./(p.nel-st.num_perc());
#endif
  // perceive one more
  for(int i=0;i<p.nel;++i)
  {
    if(!st.perc(i))
    {
      state temp=st;
      temp.add_perc(i);
      first_stage_rec(ev,temp,pelp*(inprob-mysnake),length,stim,p,inprob2,true);
//      std::cerr<<inprob<<" "<<mysnake<<"\n";
    }
  }
#ifndef PERC_ELS_ONLY  
  // remember one more
  for(int i=0;i<p.nel;++i)
  {
    if(!st.mem(i))
    {
      state temp=st;
      temp.add_mem(i);
      first_stage_rec(ev,temp,pelm*(inprob-mysnake),length,stim,p,inprob2);
    }
  }
#endif
  // reach end of first stage
  stoc mushroom(mysnake,length);
//  std::cerr<<inprob*mysnake<<" : "<<snake(st,p.q,p.r,length)*inprob2<<" = "<<mysnake*inprob/(inprob2*snake(st,p.q,p.r,length))<<"\n";;
  ev[st]+=mushroom;
}

events first_stage(const params& p,float length,int stim)
{
  state st(p.nel);
  events ev;
#ifndef NO_STAGE_1
  first_stage_rec(ev,st,1,length,stim,p,1);
#else
  ev[st]+=stoc(1.,0.);
#endif
  return ev;
}

#ifndef NO_STAGE_2
void second_stage_rec(events& ev,state st, float inprob,float intime,int stim,const params&p,bool firsttime=false)
{
  float ps=firsttime?0:pstop(st,stim,p);
//  std::cerr<<"PSTOP "<<ps<<"\n";
  state ltemp=st;
  ltemp.stop();
//   std::cerr<<"INPROB "<<inprob<<"\n";
  stoc badger(inprob*ps,intime);
  if(ps!=0) ev[ltemp]+=badger; 

//  std::cerr<<ev;

  inprob*=(1-ps);
  
  if(ps==1.f) return;
  
    float snake = 1./(
#ifndef PERC_ELS_ONLY
    p.r*(p.nel-st.num_mem())+
#endif
#ifdef PERC_STAGE_2
    p.q2*(p.nel-st.num_perc())+
#endif
    0
    );
//  std::cerr<<intime<<"\t"<<snake<<"\n";
  float pelm=p.r/(
#ifndef PERC_ELS_ONLY
    p.r*(p.nel-st.num_mem())+
#endif
#ifdef PERC_STAGE_2
    p.q2*(p.nel-st.num_perc())+
#endif
    0
  );

  float pelp=p.q2/(
#ifndef PERC_ELS_ONLY
    p.r*(p.nel-st.num_mem())+
#endif
#ifdef PERC_STAGE_2
    p.q2*(p.nel-st.num_perc())+
#endif
    0
  );

#ifdef PERC_STAGE_2
  // perceive one more
  for(int i=0;i<p.nel;++i)
  {
    if(!st.perc(i))
    {
      state temp=st;
      temp.add_perc(i);
      second_stage_rec(ev,temp,pelp*inprob,intime+snake,stim,p);
    }
  }
#endif
#ifndef PERC_ELS_ONLY
  // remember one more
  for(int i=0;i<p.nel;++i)
  {
    if(!st.mem(i))
    {
      state temp=st;
      temp.add_mem(i);
      second_stage_rec(ev,temp,pelm*inprob,intime+snake,stim,p);
    }
  }
#endif
}
#endif

events second_stage(const events& initev,const params& p,float length,int stim)
{
  events ev;
  for(events::const_iterator i=initev.begin(),k=initev.end();i!=k;++i)
  {
    if(i->second.p==0) continue;
    if(i->first.stopped())
    {
      ev[i->first]+=i->second;
    }
    else 
    {
#ifndef NO_STAGE_2
      second_stage_rec(ev,i->first,i->second.p,i->second.rt,stim,p,true);
#else
      state z=i->first;
      z.stop();
      ev[z]+=i->second;
#endif
    }
  }
  return ev;
}


#ifndef SHARED
int main(int argc,char** argv)
{
  params p;

  ++argv;
  
  p.n=std::atoi(*argv++);
  p.nel=std::atoi(*argv++);
  p.c=std::atof(*argv++);
  #ifndef NO_STAGE_1
  p.q=std::atof(*argv++);
  #endif 
  #ifndef PERC_ELS_ONLY
  p.r=std::atof(*argv++);
  #else
  p.r=0;
  #endif
  #ifdef PERC_STAGE_2
  p.q2=std::atof(*argv++);
  #endif
  p.th=std::atof(*argv++);
  p.l=std::atof(*argv++);
  
  float length=std::atof(*argv++);

  float*pr=new float[p.n*p.n];
  float*rt=new float[p.n];
#else

extern "C" void egcm(double* pars,double* pr,double *rt)
{
  params p;
  
  p.n=*pars++;
  p.nel=*pars++;
  p.c=*pars++;
  #ifndef NO_STAGE_1
  p.q=*pars++;
  #endif
  #ifndef PERC_ELS_ONLY
  p.r=*pars++;
  #else
  p.r=0;
  #endif
  #ifdef PERC_STAGE_2
  p.q2=*pars++;
  #endif
  p.th=*pars++;
  p.l=*pars++;
  
  float length=*pars++;
#endif

  #pragma omp parallel for
  for(int stim=0;stim<p.n;++stim)
  {
    rt[stim]=0;
    for(int resp=0;resp<p.n;++resp)
      pr[stim*p.n+resp]=0;

    events foo=first_stage(p,length,stim);
  
//  std::cerr<<foo;

    events bar=second_stage(foo,p,length,stim);
//  std::cerr<<foo;

    for(events::iterator i=bar.begin(),k=bar.end();i!=k;++i)
    {
      for(int resp=0;resp<p.n;++resp)
        pr[stim*p.n+resp]+=(i->second.p)*(prr(i->first,stim,resp,p));///p.n;
      rt[stim]+=i->second.p*i->second.rt;///p.n;
    }
  }
  
#ifndef SHARED
  for(int stim=0;stim<p.n;++stim)
  {
    std::cout<<stim<<"\t";
    for(int resp=0;resp<p.n;++resp)
      std::cout<<pr[stim*p.n+resp]<<"\t";
    std::cout<<rt[stim]<<"\n";
  }
//  std::cout<<bar;

  delete[] pr;
  delete[] rt;
#endif
}
